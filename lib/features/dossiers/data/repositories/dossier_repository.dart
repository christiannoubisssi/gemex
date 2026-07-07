import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/utils/json_utils.dart';
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

  /// Stream réactif sur un dossier — utilisé par dossierDetailProvider
  Stream<Dossier?> watchById(String id) {
    return _db.dossiersDao.watchById(id);
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
      typeMissionId: drift.Value(data['type_mission_id'] as String?),
      statut: const drift.Value(AppConstants.statutBrouillon),
      priorite: drift.Value(data['priorite'] as String? ?? 'normale'),
      description: drift.Value(data['description'] as String?),
      dateSinistre: drift.Value(_parseDateTime(data['date_sinistre'])),
      lieuSinistre: drift.Value(data['lieu_sinistre'] as String?),
      natureSinistre: drift.Value(nature),
      montantSinistre: drift.Value(_parseDouble(data['montant_sinistre'])),
      dateExpertise: drift.Value(_parseDateTime(data['date_expertise'])),
      compagnieAssurance: drift.Value(data['compagnie_assurance'] as String?),
      numeroPolice: drift.Value(data['numero_police'] as String?),
      courtier: drift.Value(data['courtier'] as String?),
      notesInternes: drift.Value(data['notes_internes'] as String?),
      syncStatus: const drift.Value(AppConstants.syncPending),
    );

    await _db.dossiersDao.upsert(companion);

    // Champs calculés localement (absents de `data`) mais requis côté Supabase
    final syncData = {...data, 'id': id, 'titre': titre, 'annee': now.year};

    final online = _ref.read(isOnlineProvider);
    AppLogger.d('DossierRepository', 'create $id — isOnline=$online');
    if (online) {
      await _syncToSupabase(id, syncData, 'create');
    } else {
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: 'create',
        payload: jsonEncode(toJsonSafe(syncData)),
      );
    }

    return id;
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    final now = DateTime.now();

    // updateFields = UPDATE partiel (ne nécessite pas entrepriseId/annee)
    await _db.dossiersDao.updateFields(id, DossiersCompanion(
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
      expertId: data.containsKey('expert_id')
          ? drift.Value(data['expert_id'] as String?)
          : const drift.Value.absent(),
      typeMissionId: data.containsKey('type_mission_id')
          ? drift.Value(data['type_mission_id'] as String?)
          : const drift.Value.absent(),
      dateSinistre: data.containsKey('date_sinistre')
          ? drift.Value(_parseDateTime(data['date_sinistre']))
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
      numeroPolice: data.containsKey('numero_police')
          ? drift.Value(data['numero_police'] as String?)
          : const drift.Value.absent(),
      courtier: data.containsKey('courtier')
          ? drift.Value(data['courtier'] as String?)
          : const drift.Value.absent(),
      dateExpertise: data.containsKey('date_expertise')
          ? drift.Value(_parseDateTime(data['date_expertise']))
          : const drift.Value.absent(),
      notesInternes: data.containsKey('notes_internes')
          ? drift.Value(data['notes_internes'] as String?)
          : const drift.Value.absent(),
      deadline: data.containsKey('deadline')
          ? drift.Value(_parseDateTime(data['deadline']))
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
        payload: jsonEncode(toJsonSafe({...data, 'id': id})),
      );
    }
  }

  Future<void> changerStatut(String id, String nouveauStatut,
      {String? motif}) async {
    final now = DateTime.now();
    DateTime? dateExpertise;
    DateTime? dateCloture;

    if (nouveauStatut == AppConstants.statutEnCours) dateExpertise = now;
    if (nouveauStatut == AppConstants.statutTermine) dateCloture = now;

    await _db.dossiersDao.updateStatut(
      id,
      nouveauStatut,
      dateExpertise: dateExpertise,
      dateCloture: dateCloture,
      motifAnnulation: motif,
    );

    final payload = {
      'id': id,
      'statut': nouveauStatut,
      if (motif != null) 'motif_annulation': motif,
      if (dateExpertise != null)
        'date_expertise': dateExpertise.toIso8601String(),
      if (dateCloture != null) 'date_cloture': dateCloture.toIso8601String(),
    };

    if (_ref.read(isOnlineProvider)) {
      await _syncToSupabase(id, payload, 'update');
      // Récupérer le numéro permanent assigné par le trigger Supabase lors du passage à en_cours
      if (nouveauStatut == AppConstants.statutEnCours) {
        try {
          final row = await _supabase
              .from('dossiers')
              .select('numero')
              .eq('id', id)
              .single();
          final numero = row['numero'] as String?;
          if (numero != null && !numero.contains('LOCAL')) {
            await _db.dossiersDao.updateNumero(id, numero);
          }
        } catch (e) {
          AppLogger.w('DossierRepository', 'Impossible de récupérer le numéro après en_cours: $e');
        }
      }
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
            .insert(toJsonSafe(data))
            .select('numero')
            .single();
        final serverNumero = response['numero'] as String?;
        if (serverNumero != null) {
          await _db.dossiersDao.updateNumero(id, serverNumero);
        } else {
          await _db.dossiersDao.markSynced(id);
        }
        AppLogger.i('DossierRepository', 'Dossier $id synchronisé avec Supabase');
      } else {
        await _supabase.from('dossiers').update(toJsonSafe(data)).eq('id', id);
        await _db.dossiersDao.markSynced(id);
        AppLogger.i('DossierRepository', 'Dossier $id (update) synchronisé avec Supabase');
      }
    } catch (e, s) {
      AppLogger.e('DossierRepository', 'Échec sync Supabase dossier $id ($operation)', error: e, stack: s);
      await _db.syncQueueDao.enqueue(
        entityType: 'dossier',
        entityId: id,
        operation: operation,
        payload: jsonEncode(toJsonSafe({...data, 'id': id})),
      );
    }
  }
}
