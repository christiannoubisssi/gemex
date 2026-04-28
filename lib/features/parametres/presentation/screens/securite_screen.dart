import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/parametres_service.dart';

class SecuriteScreen extends StatefulWidget {
  const SecuriteScreen({super.key});

  @override
  State<SecuriteScreen> createState() => _SecuriteScreenState();
}

class _SecuriteScreenState extends State<SecuriteScreen> {
  bool _loading = true;
  bool _saving = false;

  bool _qrActif = false;
  bool _signatureActif = false;
  bool _filigraneActif = false;
  String _hmacSecret = '';

  final _filigraneCtrl = TextEditingController();
  final _signatureCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ParametresService.getSecurite();
    if (!mounted) return;
    setState(() {
      _qrActif = data['qr_actif'] as bool;
      _signatureActif = data['signature_actif'] as bool;
      _filigraneActif = data['filigrane_actif'] as bool;
      _filigraneCtrl.text = data['filigrane_texte'] as String;
      _signatureCtrl.text = data['signature_texte'] as String;
      _hmacSecret = data['hmac_secret'] as String;
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ParametresService.saveSecurite({
      'qr_actif': _qrActif,
      'signature_actif': _signatureActif,
      'filigrane_actif': _filigraneActif,
      'filigrane_texte': _filigraneCtrl.text.trim().isEmpty ? 'ORIGINAL' : _filigraneCtrl.text.trim(),
      'signature_texte': _signatureCtrl.text.trim(),
    });
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paramètres de sécurité enregistrés')),
      );
    }
  }

  Future<void> _regenererSecret() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Régénérer la clé secrète ?'),
        content: const Text(
          'Attention : les documents déjà générés ne pourront plus être vérifiés avec cette nouvelle clé. '
          'Assurez-vous que tous les documents en circulation ont été archivés.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Régénérer'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ParametresService.regenererHmacSecret();
    final data = await ParametresService.getSecurite();
    if (mounted) {
      setState(() => _hmacSecret = data['hmac_secret'] as String);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nouvelle clé secrète générée')),
      );
    }
  }

  @override
  void dispose() {
    _filigraneCtrl.dispose();
    _signatureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sécurité des documents'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Enregistrer', style: TextStyle(color: AppColors.teal)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Éléments de sécurité en bas de page',
            subtitle: 'Appliqués au 1/6 inférieur de chaque document généré (devis, factures, rapports)',
            children: [
              SwitchListTile(
                value: _qrActif,
                onChanged: (v) => setState(() => _qrActif = v),
                title: const Text('Code QR d\'authenticité'),
                subtitle: const Text('QR encodé HMAC-SHA256 · scannable depuis l\'app'),
                secondary: const Icon(Icons.qr_code_2_outlined, color: AppColors.navy),
                activeThumbColor: AppColors.teal,
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: _signatureActif,
                onChanged: (v) => setState(() => _signatureActif = v),
                title: const Text('Bloc de signature électronique'),
                subtitle: const Text('Certifie la conformité du document'),
                secondary: const Icon(Icons.verified_outlined, color: AppColors.navy),
                activeThumbColor: AppColors.teal,
              ),
              if (_signatureActif) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: _signatureCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nom du signataire / titre',
                      hintText: 'Ex: Cabinet Maritime Gabon — Expert agréé',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                ),
              ],
              const Divider(height: 1),
              SwitchListTile(
                value: _filigraneActif,
                onChanged: (v) => setState(() => _filigraneActif = v),
                title: const Text('Filigrane diagonal'),
                subtitle: const Text('Texte en diagonale sur chaque page'),
                secondary: const Icon(Icons.water_outlined, color: AppColors.navy),
                activeThumbColor: AppColors.teal,
              ),
              if (_filigraneActif) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: _filigraneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Texte du filigrane',
                      hintText: 'ORIGINAL / COPIE CONFORME / CONFIDENTIEL',
                      prefixIcon: Icon(Icons.text_fields_outlined),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Clé secrète HMAC',
            subtitle: 'Utilisée pour signer les QR codes. Ne partagez jamais cette clé.',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _hmacSecret,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 20),
                            tooltip: 'Copier',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _hmacSecret));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Clé copiée')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh, color: AppColors.danger),
                      label: const Text('Régénérer la clé', style: TextStyle(color: AppColors.danger)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.danger),
                      ),
                      onPressed: _regenererSecret,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}
