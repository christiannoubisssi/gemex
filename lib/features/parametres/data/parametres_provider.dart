import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'parametres_service.dart';

final entrepriseProvider = FutureProvider.autoDispose<Map<String, String>>(
  (_) => ParametresService.getEntreprise(),
);

final fiscalProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (_) => ParametresService.getFiscal(),
);

final documentLayoutProvider = FutureProvider.autoDispose<Map<String, String>>(
  (_) => ParametresService.getDocumentLayout(),
);

final typesMissionProvider = FutureProvider.autoDispose<List<String>>(
  (_) => ParametresService.getTypesMission(),
);
