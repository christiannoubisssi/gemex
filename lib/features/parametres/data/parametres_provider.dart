import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'parametres_service.dart';

final entrepriseProvider = FutureProvider.autoDispose<Map<String, String>>(
  (_) => ParametresService.getEntreprise(),
);

final logoBytesProvider = FutureProvider.autoDispose<Uint8List?>(
  (_) => ParametresService.getLogoBytes(),
);

final fiscalProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (_) => ParametresService.getFiscal(),
);

final documentLayoutProvider = FutureProvider.autoDispose<Map<String, String>>(
  (_) => ParametresService.getDocumentLayout(),
);

final typesMissionProvider = FutureProvider.autoDispose<List<Map<String, String>>>(
  (_) => ParametresService.getTypesMission(),
);

final numerotationProvider = FutureProvider.autoDispose<Map<String, String>>(
  (_) => ParametresService.getNumerotation(),
);
