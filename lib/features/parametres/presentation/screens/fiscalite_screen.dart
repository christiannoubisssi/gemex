import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/parametres_service.dart';
import '../../data/parametres_provider.dart';

class FiscaliteScreen extends ConsumerStatefulWidget {
  const FiscaliteScreen({super.key});
  @override
  ConsumerState<FiscaliteScreen> createState() => _FiscaliteScreenState();
}

class _FiscaliteScreenState extends ConsumerState<FiscaliteScreen> {
  final _tvaCtrl = TextEditingController();
  final _tpsCtrl = TextEditingController();
  String _devise = 'XAF';
  bool _loading = true;
  bool _saving = false;

  static const _devises = ['XAF', 'EUR', 'USD', 'GBP'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ParametresService.getFiscal();
    _tvaCtrl.text = (data['tva_taux'] as double).toString();
    _tpsCtrl.text = (data['tps_taux'] as double).toString();
    _devise = data['devise'] as String;
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    final tva = double.tryParse(_tvaCtrl.text);
    final tps = double.tryParse(_tpsCtrl.text);
    if (tva == null || tps == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Taux invalide')));
      return;
    }
    setState(() => _saving = true);
    await ParametresService.saveFiscal(tva, tps, _devise);
    ref.invalidate(fiscalProvider);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Fiscalité enregistrée')));
    }
  }

  @override
  void dispose() {
    _tvaCtrl.dispose();
    _tpsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Fiscalité')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.amber.shade50,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Les taux modifiés s\'appliquent aux nouveaux documents uniquement.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _tvaCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Taux TVA (%)',
                suffixText: '%',
                prefixIcon: Icon(Icons.percent),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tpsCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Taux TPS/CSS (%)',
                suffixText: '%',
                prefixIcon: Icon(Icons.percent),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _devise,
              decoration: const InputDecoration(
                labelText: 'Devise',
                prefixIcon: Icon(Icons.attach_money),
              ),
              items: _devises
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _devise = v ?? 'XAF'),
            ),
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
