import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/numero_format_utils.dart';
import '../../data/parametres_provider.dart';
import '../../data/parametres_service.dart';

class NumerotationScreen extends ConsumerStatefulWidget {
  const NumerotationScreen({super.key});
  @override
  ConsumerState<NumerotationScreen> createState() => _NumerotationScreenState();
}

class _NumerotationScreenState extends ConsumerState<NumerotationScreen> {
  final _devisCtrl = TextEditingController();
  final _factureCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ParametresService.getNumerotation();
    _devisCtrl.text = data['format_devis']!;
    _factureCtrl.text = data['format_facture']!;
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ParametresService.saveNumerotation(
        _devisCtrl.text.trim(), _factureCtrl.text.trim());
    ref.invalidate(numerotationProvider);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Numérotation enregistrée')));
    }
  }

  @override
  void dispose() {
    _devisCtrl.dispose();
    _factureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final annee = DateTime.now().year;
    return Scaffold(
      appBar: AppBar(title: const Text('Numérotation des documents')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.amber.shade50,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Jetons disponibles, séparés par "-" :\n'
                        '• PREFIXE — DEV ou FAC selon le document\n'
                        '• AAAA — année\n'
                        '• MMAA — mois + année (ex : 0626)\n'
                        '• ABREV — abréviation du type de mission du dossier lié (vide si absent)\n'
                        '• INITIALES — initiales de l\'auteur du document (vide si non renseignées)\n'
                        '• NNNN — numéro séquentiel annuel (le nombre de N définit le nombre de chiffres)\n\n'
                        'Les segments ABREV/INITIALES vides sont automatiquement retirés du numéro.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Devis', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _devisCtrl,
              decoration: const InputDecoration(
                labelText: 'Format devis',
                hintText: 'PREFIXE-AAAA-NNNN',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 4),
            _Apercu(format: _devisCtrl.text, prefixe: 'DEV', annee: annee),
            const SizedBox(height: 24),
            const Text('Factures', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _factureCtrl,
              decoration: const InputDecoration(
                labelText: 'Format facture',
                hintText: 'PREFIXE-AAAA-NNNN',
                prefixIcon: Icon(Icons.receipt_long_outlined),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 4),
            _Apercu(format: _factureCtrl.text, prefixe: 'FAC', annee: annee),
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
}

class _Apercu extends StatelessWidget {
  final String format;
  final String prefixe;
  final int annee;
  const _Apercu({required this.format, required this.prefixe, required this.annee});

  @override
  Widget build(BuildContext context) {
    final format0 = format.trim();
    final exemple = format0.isEmpty
        ? '—'
        : NumeroFormatUtils.formater(
            format: format0,
            prefixe: prefixe,
            annee: annee,
            sequence: 1,
            abrev: 'MAR',
            initiales: 'CN',
          );
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        'Aperçu : $exemple',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}
