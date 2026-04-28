import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../providers/piece_jointe_provider.dart';

class PiecesJointesScreen extends ConsumerWidget {
  final String dossierId;
  const PiecesJointesScreen({super.key, required this.dossierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(piecesJointesProvider(dossierId));

    return Scaffold(
      appBar: AppBar(title: const Text('Pièces jointes')),
      floatingActionButton: _AddFab(dossierId: dossierId),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (pieces) {
          if (pieces.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.attach_file_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune pièce jointe',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez des photos ou documents via le bouton +',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final images = pieces.where((p) => p.typeFichier == 'image').toList();
          final docs = pieces.where((p) => p.typeFichier != 'image').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (images.isNotEmpty) ...[
                  const Text('Photos',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: images.length,
                    itemBuilder: (_, i) => _ImageTile(
                      piece: images[i],
                      onDelete: () => _confirmerSuppression(context, ref, images[i].id),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (docs.isNotEmpty) ...[
                  const Text('Documents',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                  const SizedBox(height: 8),
                  ...docs.map((d) => _DocumentTile(
                        piece: d,
                        onDelete: () => _confirmerSuppression(context, ref, d.id),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmerSuppression(
      BuildContext context, WidgetRef ref, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Supprimer cette pièce jointe ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(pieceJointeNotifierProvider.notifier).delete(id);
    }
  }
}

// ── FAB avec menu source ─────────────────────────────────────────────────────

class _AddFab extends ConsumerWidget {
  final String dossierId;
  const _AddFab({required this.dossierId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showSourceMenu(context, ref),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _showSourceMenu(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.teal),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ref, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.teal),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ref, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.teal),
              title: const Text('Choisir un document'),
              onTap: () {
                Navigator.pop(context);
                _pickDocument(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 80);
    if (xfile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final destDir = Directory(p.join(appDir.path, 'pieces_jointes', dossierId));
    await destDir.create(recursive: true);

    final ext = p.extension(xfile.path);
    final nom = '${const Uuid().v4()}$ext';
    final dest = p.join(destDir.path, nom);
    await File(xfile.path).copy(dest);

    final stat = await File(dest).stat();

    await ref.read(pieceJointeNotifierProvider.notifier).add(
          dossierId: dossierId,
          cheminLocal: dest,
          nom: nom,
          typeFichier: 'image',
          taille: stat.size,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Photo ajoutée')));
    }
  }

  Future<void> _pickDocument(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final destDir = Directory(p.join(appDir.path, 'pieces_jointes', dossierId));
    await destDir.create(recursive: true);

    final ext = p.extension(file.path!);
    final nom = '${const Uuid().v4()}$ext';
    final dest = p.join(destDir.path, nom);
    await File(file.path!).copy(dest);

    final typeFichier = ext.toLowerCase() == '.pdf' ? 'pdf' : 'document';

    await ref.read(pieceJointeNotifierProvider.notifier).add(
          dossierId: dossierId,
          cheminLocal: dest,
          nom: file.name,
          typeFichier: typeFichier,
          taille: file.size,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Document ajouté')));
    }
  }
}

// ── Widgets d'affichage ──────────────────────────────────────────────────────

class _ImageTile extends StatelessWidget {
  final PiecesJointe piece;
  final VoidCallback onDelete;
  const _ImageTile({required this.piece, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final file = File(piece.cheminLocal);
    return GestureDetector(
      onTap: () => _showFullscreen(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: file.existsSync()
                ? Image.file(file, fit: BoxFit.cover)
                : Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                  ),
          ),
          // Badge sync en attente
          if (piece.syncStatus == 'pending')
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_outlined, size: 12, color: Colors.white),
              ),
            ),
          // Bouton supprimer
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullscreen(BuildContext context) {
    final file = File(piece.cheminLocal);
    if (!file.existsSync()) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(child: Center(child: Image.file(file))),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final PiecesJointe piece;
  final VoidCallback onDelete;
  const _DocumentTile({required this.piece, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final icon = piece.typeFichier == 'pdf'
        ? Icons.picture_as_pdf_outlined
        : Icons.description_outlined;
    final color = piece.typeFichier == 'pdf' ? Colors.red : AppColors.navy;
    final taille = piece.taille != null ? _formatSize(piece.taille!) : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(piece.nom, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          taille.isNotEmpty ? '$taille · ${_formatDate(piece.createdAt)}' : _formatDate(piece.createdAt),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (piece.syncStatus == 'pending')
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.cloud_upload_outlined, size: 18, color: AppColors.gold),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes o';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} Ko';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
