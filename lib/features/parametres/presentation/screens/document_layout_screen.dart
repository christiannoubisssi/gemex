import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/parametres_service.dart';
import '../../data/parametres_provider.dart';

class DocumentLayoutScreen extends ConsumerStatefulWidget {
  const DocumentLayoutScreen({super.key});
  @override
  ConsumerState<DocumentLayoutScreen> createState() => _DocumentLayoutScreenState();
}

class _DocumentLayoutScreenState extends ConsumerState<DocumentLayoutScreen> {
  final _enTeteCtrl = TextEditingController();
  final _piedCtrl = TextEditingController();
  final _mentionsCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ParametresService.getDocumentLayout();
    _enTeteCtrl.text = data['en_tete'] ?? '';
    _piedCtrl.text = data['pied_de_page'] ?? '';
    _mentionsCtrl.text = data['mentions_legales'] ?? '';
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ParametresService.saveDocumentLayout({
      'en_tete': _enTeteCtrl.text,
      'pied_de_page': _piedCtrl.text,
      'mentions_legales': _mentionsCtrl.text,
    });
    ref.invalidate(documentLayoutProvider);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Mise en page enregistrée')));
    }
  }

  @override
  void dispose() {
    _enTeteCtrl.dispose();
    _piedCtrl.dispose();
    _mentionsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Mise en page documents')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ces textes apparaîtront sur tous vos devis et factures PDF.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _area(_enTeteCtrl, 'En-tête', 'Coordonnées, slogan…', 4),
            _area(_piedCtrl, 'Pied de page', 'Coordonnées bancaires, site web…', 3),
            _area(_mentionsCtrl, 'Mentions légales', 'RC, NIF, TVA…', 4),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_outlined),
                label: const Text('Enregistrer'),
                onPressed: _saving ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _area(TextEditingController ctrl, String label, String hint, int lines) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
