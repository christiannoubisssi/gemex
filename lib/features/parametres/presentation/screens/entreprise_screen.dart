import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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
  Uint8List? _logoBytes;

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
    _logoBytes = await ParametresService.getLogoBytes();
    setState(() => _loading = false);
  }

  Future<void> _choisirLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes == null) return;
    await ParametresService.saveLogoBase64(base64Encode(bytes));
    ref.invalidate(logoBytesProvider);
    setState(() => _logoBytes = bytes);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logo enregistré')));
    }
  }

  Future<void> _supprimerLogo() async {
    await ParametresService.removeLogo();
    ref.invalidate(logoBytesProvider);
    setState(() => _logoBytes = null);
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
              _logoSection(),
              const SizedBox(height: 24),
              _field(_nomCtrl, 'Nom du cabinet', Icons.business_outlined, required: true),
              _field(_adresseCtrl, 'Adresse', Icons.location_on_outlined, maxLines: 3),
              // Téléphone et Email côte à côte
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _telCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // RCCM et NIF côte à côte
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _rccmCtrl,
                        decoration: const InputDecoration(
                          labelText: 'N° RCCM',
                          prefixIcon: Icon(Icons.numbers_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _nifCtrl,
                        decoration: const InputDecoration(
                          labelText: 'N° NIF / Identifiant fiscal',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _logoSection() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _logoBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(_logoBytes!, fit: BoxFit.contain),
                )
              : const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.upload_outlined, size: 18),
              label: Text(_logoBytes == null ? 'Charger un logo' : 'Changer le logo'),
              onPressed: _choisirLogo,
            ),
            if (_logoBytes != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: _supprimerLogo,
                tooltip: 'Supprimer le logo',
              ),
            ],
          ],
        ),
      ],
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
