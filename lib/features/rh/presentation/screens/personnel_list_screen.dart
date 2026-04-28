import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../providers/personnel_provider.dart';

class PersonnelListScreen extends ConsumerStatefulWidget {
  const PersonnelListScreen({super.key});

  @override
  ConsumerState<PersonnelListScreen> createState() => _PersonnelListScreenState();
}

class _PersonnelListScreenState extends ConsumerState<PersonnelListScreen> {
  bool _showInactifs = false;

  @override
  Widget build(BuildContext context) {
    final async = _showInactifs
        ? ref.watch(allPersonnelProvider)
        : ref.watch(personnelListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personnel'),
        actions: [
          IconButton(
            icon: Icon(_showInactifs ? Icons.visibility_off : Icons.visibility),
            tooltip: _showInactifs ? 'Masquer inactifs' : 'Afficher inactifs',
            onPressed: () => setState(() => _showInactifs = !_showInactifs),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Ajouter'),
        onPressed: () => context.push('/rh/personnel/new'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text('Aucun employé', style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => _PersonnelTile(person: list[i]),
          );
        },
      ),
    );
  }
}

class _PersonnelTile extends StatelessWidget {
  final PersonnelData person;
  const _PersonnelTile({required this.person});

  @override
  Widget build(BuildContext context) {
    final nomComplet = [person.prenom, person.nom].whereType<String>().join(' ');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: person.actif ? AppColors.teal : Colors.grey,
        child: Text(
          person.nom.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(nomComplet),
      subtitle: Text(
        [person.poste, person.typeContrat].whereType<String>().join(' · '),
        style: const TextStyle(fontSize: 12),
      ),
      trailing: person.actif
          ? null
          : const Chip(
              label: Text('Inactif', style: TextStyle(fontSize: 11)),
              padding: EdgeInsets.zero,
            ),
      onTap: () => context.push('/rh/personnel/${person.id}'),
    );
  }
}
