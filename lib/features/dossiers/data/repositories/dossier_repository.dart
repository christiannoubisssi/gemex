import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../database/app_database.dart';

final dossierRepositoryProvider = Provider<DossierRepository>((ref) {
  return DossierRepository(
    db: AppDatabase.instance,
    supabase: Supabase.instance.client,
    ref: ref,
  );
});

class DossierRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  DossierRepository({
    required AppDatabase db,
    required SupabaseClient supabase,
    required Ref ref,
  })  : _db = db,
        _supabase = supabase,
        _ref = ref;

  Future<List<Dossier>> getAll({String? statut, String? search, String? clientId}) {
    return _db.dossiersDao.getAll(statut: statut, search: search, clientId: clientId);
  }

  Stream<List<Dossier>> watchAll({String? statut}) {
    return _db.dossiersDao.watchAll(statut: statut);
  }

  Future<Dossier?> getById(String id) {
    return _db.dossiersDao.getById(id);
  }

  Future<List<Dossier>> getUrgents() {
    return _db.dossiersDao.getUrgents();
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(' ', ''));
  }

  static DateTime? _parseDateTime(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  Future<String> create(Map<String, dynamic> data) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final numero = FormatUtils.generateLocalNumero('AV');
    final nature = data['nature_sinistre'] as String?;
    final titre = (nature != null && nature.isNotEmpty) ? nature : numero;

    final companion = DossiersCompanion.insert(
      id: id,
      entrepriseId: data['entreprise_id'] as String? ?? '',
      titre: titre,
      annee: now.year,
      numero: drift.Value(numero),
      clientId: drift.Value(data['client_id'] as String?),
      expertId: drift.Value(data['expert_id'] as String?),
      statut: const drift.Value('nouveau'),
      priorite: drift.Value(data['priorite'] as String? ?? 'normale'),
      description: drift.Value(data['description'] as String?),
      dateSinistre: drift.Value(_parseDateTime(data['date_sinistre'])),
      lieuSinistre: drift.Value(data['lieu_sinistre'] as String?),
      natureSinistre: drift.Value(nature),
      montantSinistre: drift.Value(_parseDouble(data['montant_sinistre'])),
      compagnieAssurance: drift.Value(data['compagnie_assurance'] as String?),
      numeroPolice: drift.Value(data['numero_police'] as String?),
      courtier: drift.Value(data['courtier'] as String?),
      notesInternes: drift.Value(data['notes_internes'] as String?),
      syncStatus: const drift.Value(AppConstants.syncPending),
    );

    await _db.dossiersDao.upsert(companion);

    if (_ref.read(isOnlineProvider)) {
      await _syncToSupabase(id, {...data, 'id': id}, 'create');
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: 'create',
        payload: jsonEncode({...data, 'id': id}),
      );
    }

    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    final now = DateTime.now();

    await _db.dossiersDao.upsert(DossiersCompanion(
      id: drift.Value(id),
      titre: data.containsKey('nature_sinistre')
          ? drift.Value((data['nature_sinistre'] as String?)?.isNotEmpty == true
              ? data['nature_sinistre'] as String
              : (data['titre'] as String? ?? ''))
          : const drift.Value.absent(),
      description: data.containsKey('description')
          ? drift.Value(data['description'] as String?)
          : const drift.Value.absent(),
      priorite: data.containsKey('priorite')
          ? drift.Value(data['priorite'] as String)
          : const drift.Value.absent(),
      clientId: data.containsKey('client_id')
          ? drift.Value(data['client_id'] as String?)
          : const drift.Value.absent(),
      lieuSinistre: data.containsKey('lieu_sinistre')
          ? drift.Value(data['lieu_sinistre'] as String?)
          : const drift.Value.absent(),
      natureSinistre: data.containsKey('nature_sinistre')
          ? drift.Value(data['nature_sinistre'] as String?)
          : const drift.Value.absent(),
      montantSinistre: data.containsKey('montant_sinistre')
          ? drift.Value(_parseDouble(data['montant_sinistre']))
          : const drift.Value.absent(),
      compagnieAssurance: data.containsKey('compagnie_assurance')
          ? drift.Value(data['compagnie_assurance'] as String?)
          : const drift.Value.absent(),
      notesInternes: data.containsKey('notes_internes')
          ? drift.Value(data['notes_internes'] as String?)
          : const drift.Value.absent(),
      syncStatus: const drift.Value(AppConstants.syncPending),
      updatedAt: drift.Value(now),
    ));

    if (_ref.read(isOnlineProvider)) {
      await _syncToSupabase(id, data, 'update');
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: 'update',
        payload: jsonEncode({...data, 'id': id}),
      );
    }
  }

  Future<void> changerStatut(String id, String nouveauStatut,
      {String? motif}) async {
    final now = DateTime.now();
    DateTime? dateExpertise;
    DateTime? dateRapport;
    DateTime? dateCloture;

    if (nouveauStatut == AppConstants.statutExpertise) dateExpertise = now;
    if (nouveauStatut == AppConstants.statutRapport) dateRapport = now;
    if (nouveauStatut == AppConstants.statutClos) dateCloture = now;

    await _db.dossiersDao.updateStatut(
      id,
      nouveauStatut,
      dateExpertise: dateExpertise,
      dateRapport: dateRapport,
      dateCloture: dateCloture,
    );

    final payload = {
      'id': id,
      'statut': nouveauStatut,
      if (motif != null) 'motif_annulation': motif,
      if (dateExpertise != null)
        'date_expertise': dateExpertise.toIso8601String(),
      if (dateRapport != null) 'date_rapport': dateRapport.toIso8601String(),
      if (dateCloture != null) 'date_cloture': dateCloture.toIso8601String(),
    };

    if (_ref.read(isOnlineProvider)) {
      await _syncToSupabase(id, payload, 'update');
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: 'update',
        payload: jsonEncode(payload),
      );
    }
  }

  Future<Map<String, int>> getStatsCounts() {
    return _db.dossiersDao.getStatsCounts();
  }

  Future<void> _syncToSupabase(
      String id, Map<String, dynamic> data, String operation) async {
    try {
      if (operation == 'create') {
        final response = await _supabase
            .from('dossiers')
            .insert(data)
            .select('numero')
            .single();
        final serverNumero = response['numero'] as String?;
        if (serverNumero != null) {
          await _db.dossiersDao.updateNumero(id, serverNumero);
        } else {
          await _db.dossiersDao.markSynced(id);
        }
      } else {
        await _supabase.from('dossiers').update(data).eq('id', id);
        await _db.dossiersDao.markSynced(id);
      }
    } catch (_) {
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: operation,
        payload: jsonEncode({...data, 'id': id}),
      );
    }
  }
}
