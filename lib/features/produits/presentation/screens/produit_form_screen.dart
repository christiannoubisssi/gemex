import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/produit_repository.dart';
import '../providers/produit_provider.dart';

class ProduitFormScreen extends ConsumerStatefulWidget {
  final String? id;
  const ProduitFormScreen({super.key, this.id});

  @override
  ConsumerState<ProduitFormScreen> createState() => _ProduitFormScreenState();
}

class _ProduitFormScreenState extends ConsumerState<ProduitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _uniteCtrl = TextEditingController(text: 'unité');
  final _prixVenteCtrl = TextEditingController();
  final _prixAchatCtrl = TextEditingController();
  final _categorieCtrl = TextEditingController();
  final _stockMinCtrl = TextEditingController(text: '0');
  bool _estVente = true;
  bool _estAchat = false;
  bool _loading = false;
  Produit? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loadExisting();
    } else {
      _loadNextCode();
    }
  }

  Future<void> _loadNextCode() async {
    final code = await ref.read(produitNextCodeProvider.future);
    if (mounted) setState(() => _codeCtrl.text = code);
  }

  Future<void> _loadExisting() async {
    final p = await ref.read(produitRepositoryProvider).getById(widget.id!);
    if (p == null || !mounted) return;
    setState(() {
      _existing = p;
      _codeCtrl.text = p.code;
      _nomCtrl.text = p.nom;
      _descCtrl.text = p.description ?? '';
      _uniteCtrl.text = p.unite;
      _prixVenteCtrl.text = p.prixVente > 0 ? p.prixVente.toString() : '';
      _prixAchatCtrl.text = p.prixAchat > 0 ? p.prixAchat.toString() : '';
      _categorieCtrl.text = p.categorie ?? '';
      _stockMinCtrl.text = p.stockMin > 0 ? p.stockMin.toString() : '0';
      _estVente = p.estVente;
      _estAchat = p.estAchat;
    });
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nomCtrl.dispose();
    _descCtrl.dispose();
    _uniteCtrl.dispose();
    _prixVenteCtrl.dispose();
    _prixAchatCtrl.dispose();
    _categorieCtrl.dispose();
    _stockMinCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_estVente && !_estAchat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cochez au moins Vente ou Achat')),
      );
      return;
    }
    setState(() => _loading = true);

    final data = {
      'entreprise_id': 'default',
      'code': _codeCtrl.text.trim(),
      'nom': _nomCtrl.text.trim(),
      'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      'unite': _uniteCtrl.text.trim(),
      'prix_vente': double.tryParse(_prixVenteCtrl.text) ?? 0.0,
      'prix_achat': double.tryParse(_prixAchatCtrl.text) ?? 0.0,
      'est_vente': _estVente,
      'est_achat': _estAchat,
      'categorie': _categorieCtrl.text.trim().isEmpty ? null : _categorieCtrl.text.trim(),
      'stock_min': double.tryParse(_stockMinCtrl.text) ?? 0.0,
    };

    final notifier = ref.read(produitNotifierProvider.notifier);
    if (_existing != null) {
      await notifier.updateProduit(_existing!.id, data);
    } else {
      await notifier.create(data);
    }

    if (mounted) {
      setState(() => _loading = false);
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_existing != null ? 'Produit modifié' : 'Produit créé')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Modifier le produit' : 'Nouveau produit')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Code + Nom
                    Row(
                      children: [
                        SizedBox(
                          width: 130,
                          child: TextFormField(
                            controller: _codeCtrl,
                            decoration: const InputDecoration(labelText: 'Code *'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _nomCtrl,
                            decoration: const InputDecoration(labelText: 'Nom du produit *'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    // Unité + catégorie
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _uniteCtrl,
                            decoration: const InputDecoration(labelText: 'Unité'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _categorieCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Catégorie',
                              hintText: 'Fournitures, Services…',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cases Vente / Achat
                    const Text('Type de produit', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Vente'),
                            subtitle: const Text('Disponible dans devis / factures',
                                style: TextStyle(fontSize: 11)),
                            value: _estVente,
                            onChanged: (v) => setState(() => _estVente = v!),
                            activeColor: AppColors.teal,
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: _estVente ? AppColors.teal : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Achat'),
                            subtitle: const Text('Disponible dans charges / achats',
                                style: TextStyle(fontSize: 11)),
                            value: _estAchat,
                            onChanged: (v) => setState(() => _estAchat = v!),
                            activeColor: AppColors.primary,
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: _estAchat ? AppColors.primary : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Prix
                    Row(
                      children: [
                        if (_estVente)
                          Expanded(
                            child: TextFormField(
                              controller: _prixVenteCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Prix de vente (FCFA)',
                                prefixIcon: Icon(Icons.sell_outlined),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        if (_estVente && _estAchat) const SizedBox(width: 12),
                        if (_estAchat)
                          Expanded(
                            child: TextFormField(
                              controller: _prixAchatCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Prix d\'achat (FCFA)',
                                prefixIcon: Icon(Icons.shopping_cart_outlined),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stock min
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _stockMinCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Stock minimum (alerte)',
                          prefixIcon: Icon(Icons.inventory_outlined),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bouton
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save_outlined),
                        label: Text(isEdit ? 'Enregistrer les modifications' : 'Créer le produit'),
                        onPressed: _save,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
