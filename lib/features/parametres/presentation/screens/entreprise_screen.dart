import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/parametres_service.dart';
import '../../data/parametres_provider.dart';

class EntrepriseScreen extends ConsumerStatefulWidget {
  const EntrepriseScreen({super.key});
  @override
  ConsumerState<EntrepriseScreen> createState() => _EntrepriseScreenState();
}

class _EntrepriseScreenState extends ConsumerState<EntrepriseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _rccmCtrl = TextEditingController();
  final _nifCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ParametresService.getEntreprise();
    _nomCtrl.text = data['nom'] ?? '';
    _adresseCtrl.text = data['adresse'] ?? '';
    _telCtrl.text = data['telephone'] ?? '';
    _emailCtrl.text = data['email'] ?? '';
    _rccmCtrl.text = data['rccm'] ?? '';
    _nifCtrl.text = data['nif'] ?? '';
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ParametresService.saveEntreprise({
      'nom': _nomCtrl.text,
      'adresse': _adresseCtrl.text,
      'telephone': _telCtrl.text,
      'email': _emailCtrl.text,
      'rccm': _rccmCtrl.text,
      'nif': _nifCtrl.text,
    });
    ref.invalidate(entrepriseProvider);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Informations enregistrées')));
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose(); _adresseCtrl.dispose(); _telCtrl.dispose();
    _emailCtrl.dispose(); _rccmCtrl.dispose(); _nifCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Informations entreprise')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _field(_nomCtrl, 'Nom du cabinet', Icons.business_outlined, required: true),
              _field(_adresseCtrl, 'Adresse', Icons.location_on_outlined, maxLines: 3),
              _field(_telCtrl, 'Téléphone', Icons.phone_outlined, keyboard: TextInputType.phone),
              _field(_emailCtrl, 'Email', Icons.email_outlined, keyboard: TextInputType.emailAddress),
              _field(_rccmCtrl, 'N° RCCM', Icons.numbers_outlined),
              _field(_nifCtrl, 'N° NIF / Identifiant fiscal', Icons.badge_outlined),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Enregistrer'),
                  onPressed: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {bool required = false, int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: required
            ? (v) => (v == null || v.isEmpty) ? 'Champ requis' : null
            : null,
      ),
    );
  }
}
