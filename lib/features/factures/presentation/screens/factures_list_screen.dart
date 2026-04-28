import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/facture_provider.dart';

class FacturesListScreen extends ConsumerStatefulWidget {
  const FacturesListScreen({super.key});
  @override
  ConsumerState<FacturesListScreen> createState() => _FacturesListScreenState();
}

class _FacturesListScreenState extends ConsumerState<FacturesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const _tabs = [null, 'emise', 'partiellement_payee', 'payee', 'annulee'];
  static const _tabLabels = ['Toutes', 'Émises', 'Part. payées', 'Payées', 'Annulées'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((statut) {
          final async = ref.watch(facturesProvider(statut));
          return async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (factures) {
              if (factures.isEmpty) return const Center(child: Text('Aucune facture'));
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: factures.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final f = factures[i];
                  final enRetard = f.statut != 'payee' &&
                      f.statut != 'annulee' &&
                      f.dateEcheance.isBefore(DateTime.now());
                  return Card(
                    child: ListTile(
                      onTap: () => context.push('/factures/${f.id}'),
                      title: Row(children: [
                        Text(
                          f.numero ?? '—',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
                        ),
                        if (enRetard) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(8)),
                            child: const Text('En retard', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ],
                      ]),
                      subtitle: Text(AppConstants.factureStatutLabels[f.statut] ?? f.statut),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(FormatUtils.formatFcfa(f.montantTtc), style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (f.montantRestant > 0)
                            Text(
                              'Reste : ${FormatUtils.formatFcfa(f.montantRestant)}',
                              style: const TextStyle(color: AppColors.danger, fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
