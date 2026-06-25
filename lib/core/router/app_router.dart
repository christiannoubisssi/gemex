import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dossiers/presentation/screens/dossiers_list_screen.dart';
import '../../features/dossiers/presentation/screens/dossier_detail_screen.dart';
import '../../features/dossiers/presentation/screens/dossier_form_screen.dart';
import '../../features/dossiers/presentation/screens/document_rapport_form_screen.dart';
import '../../shared/services/dossier_documents_service.dart';
import '../../features/clients/presentation/screens/clients_list_screen.dart';
import '../../features/clients/presentation/screens/client_detail_screen.dart';
import '../../features/clients/presentation/screens/client_form_screen.dart';
import '../../features/devis/presentation/screens/devis_list_screen.dart';
import '../../features/devis/presentation/screens/devis_detail_screen.dart';
import '../../features/devis/presentation/screens/devis_form_screen.dart';
import '../../features/factures/presentation/screens/factures_list_screen.dart';
import '../../features/factures/presentation/screens/facture_detail_screen.dart';
import '../../features/factures/presentation/screens/facture_form_screen.dart';
import '../../features/comptabilite/presentation/screens/comptabilite_screen.dart';
import '../../features/comptabilite/presentation/screens/charge_form_screen.dart';
import '../../features/charges_modeles/presentation/screens/charges_modeles_list_screen.dart';
import '../../features/charges_modeles/presentation/screens/charges_modeles_form_screen.dart';
import '../../features/charges_modeles/presentation/screens/charges_modeles_detail_screen.dart';
import '../../features/taxes/presentation/screens/taxes_screen.dart';
import '../../features/rh/presentation/screens/rh_dashboard_screen.dart';
import '../../features/rh/presentation/screens/personnel_list_screen.dart';
import '../../features/rh/presentation/screens/personnel_form_screen.dart';
import '../../features/rh/presentation/screens/personnel_detail_screen.dart';
import '../../features/rh/presentation/screens/conges_screen.dart';
import '../../features/paie/presentation/screens/paie_screen.dart';
import '../../features/parametres/presentation/screens/parametres_screen.dart';
import '../../features/parametres/presentation/screens/entreprise_screen.dart';
import '../../features/parametres/presentation/screens/document_layout_screen.dart';
import '../../features/parametres/presentation/screens/fiscalite_screen.dart';
import '../../features/parametres/presentation/screens/types_mission_screen.dart';
import '../../features/parametres/presentation/screens/numerotation_screen.dart';
import '../../features/parametres/presentation/screens/utilisateurs_screen.dart';
import '../../features/parametres/presentation/screens/profil_screen.dart';
import '../../features/parametres/presentation/screens/securite_screen.dart';
import '../../features/pieces_jointes/presentation/screens/pieces_jointes_screen.dart';
import '../../features/securite/presentation/screens/scanner_screen.dart';
import '../../features/produits/presentation/screens/produits_list_screen.dart';
import '../../features/produits/presentation/screens/produit_form_screen.dart';
import '../../features/stock/presentation/screens/stock_screen.dart';
import '../shell/main_shell.dart';
import '../widgets/log_console_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = GoRouterRefreshStream(ref.watch(authStateProvider.stream));

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      // Lecture directe Supabase — toujours à jour même si les providers sont en cache
      final isAuthenticated =
          Supabase.instance.client.auth.currentUser != null;
      final isLoginRoute = state.matchedLocation.startsWith('/login');

      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && isLoginRoute) return '/';
      return null;
    },
    routes: [
      // Routes sans shell (auth)
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'reset-password',
            builder: (_, __) => const ResetPasswordScreen(),
          ),
        ],
      ),

      // Routes avec shell (navigation principale)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
          GoRoute(
            path: '/dossiers',
            builder: (_, __) => const DossiersListScreen(),
            routes: [
              GoRoute(path: 'new', builder: (_, __) => const DossierFormScreen()),
              GoRoute(
                path: ':id',
                builder: (_, state) => DossierDetailScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) => DossierFormScreen(id: state.pathParameters['id']),
                  ),
                  GoRoute(
                    path: 'documents/:type',
                    builder: (_, state) => DocumentRapportFormScreen(
                      dossierId: state.pathParameters['id']!,
                      type: TypeDocumentMetier.values.firstWhere(
                        (t) => t.name == state.pathParameters['type'],
                        orElse: () => TypeDocumentMetier.ordreMission,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/clients',
            builder: (_, __) => const ClientsListScreen(),
            routes: [
              GoRoute(path: 'new', builder: (_, __) => const ClientFormScreen()),
              GoRoute(
                path: ':id',
                builder: (_, state) => ClientDetailScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) => ClientFormScreen(id: state.pathParameters['id']),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/devis',
            builder: (_, __) => const DevisListScreen(),
            routes: [
              GoRoute(path: 'new', builder: (_, state) {
                final dossierId = state.uri.queryParameters['dossierId'];
                return DevisFormScreen(dossierId: dossierId);
              }),
              GoRoute(
                path: ':id',
                builder: (_, state) => DevisDetailScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) => DevisFormScreen(id: state.pathParameters['id']),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/factures',
            builder: (_, __) => const FacturesListScreen(),
            routes: [
              GoRoute(path: 'new', builder: (_, state) {
                final dossierId = state.uri.queryParameters['dossierId'];
                final devisId = state.uri.queryParameters['devisId'];
                return FactureFormScreen(dossierId: dossierId, devisId: devisId);
              }),
              GoRoute(
                path: ':id',
                builder: (_, state) => FactureDetailScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) => FactureFormScreen(id: state.pathParameters['id']),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/produits',
            builder: (_, __) => const ProduitsListScreen(),
            routes: [
              GoRoute(path: 'new', builder: (_, __) => const ProduitFormScreen()),
              GoRoute(
                path: ':id',
                builder: (_, state) => const SizedBox(), // détail futur
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) => ProduitFormScreen(id: state.pathParameters['id']),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(path: '/stock', builder: (_, __) => const StockScreen()),
          GoRoute(
            path: '/comptabilite',
            builder: (_, __) => const ComptabiliteScreen(),
            routes: [
              GoRoute(path: 'charges/new', builder: (_, __) => const ChargeFormScreen()),
              GoRoute(path: 'taxes', builder: (_, __) => const TaxesScreen()),
              GoRoute(
                path: 'charges-modeles',
                builder: (_, __) => const ChargesModelesListScreen(),
                routes: [
                  GoRoute(path: 'new', builder: (_, __) => const ChargesModelesFormScreen()),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        ChargesModeleDetailScreen(id: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/rh',
            builder: (_, __) => const RhDashboardScreen(),
            routes: [
              GoRoute(
                path: 'personnel',
                builder: (_, __) => const PersonnelListScreen(),
                routes: [
                  GoRoute(path: 'new', builder: (_, __) => const PersonnelFormScreen()),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        PersonnelDetailScreen(id: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) =>
                            PersonnelFormScreen(id: state.pathParameters['id']),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(path: 'conges', builder: (_, __) => const CongesScreen()),
            ],
          ),
          GoRoute(path: '/paie', builder: (_, __) => const PaieScreen()),
          GoRoute(
            path: '/parametres',
            builder: (_, __) => const ParametresScreen(),
            routes: [
              GoRoute(path: 'profil', builder: (_, __) => const ProfilScreen()),
              GoRoute(path: 'entreprise', builder: (_, __) => const EntrepriseScreen()),
              GoRoute(path: 'documents', builder: (_, __) => const DocumentLayoutScreen()),
              GoRoute(path: 'fiscalite', builder: (_, __) => const FiscaliteScreen()),
              GoRoute(path: 'types-mission', builder: (_, __) => const TypesMissionScreen()),
              GoRoute(path: 'numerotation', builder: (_, __) => const NumerotationScreen()),
              GoRoute(path: 'utilisateurs', builder: (_, __) => const UtilisateursScreen()),
              GoRoute(path: 'securite', builder: (_, __) => const SecuriteScreen()),
            ],
          ),
          GoRoute(path: '/securite/scanner', builder: (_, __) => const ScannerScreen()),
          GoRoute(path: '/logs', builder: (_, __) => const LogConsoleScreen()),
          GoRoute(
            path: '/dossiers/:dossierId/pieces-jointes',
            builder: (_, state) =>
                PiecesJointesScreen(dossierId: state.pathParameters['dossierId']!),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
