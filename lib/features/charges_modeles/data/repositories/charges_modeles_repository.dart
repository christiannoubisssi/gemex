import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../database/app_database.dart';

final chargesModelesRepositoryProvider = Provider<ChargesModelesRepository>((ref) {
  return ChargesModelesRepository(db: AppDatabase.instance, supabase: Supabase.instance.client, ref: ref);
});

class ChargesModelesRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final Ref _ref;

  ChargesModelesRepository({required AppDatabase db, required SupabaseClient supabase, required Ref ref})
      : _db = db, _supabase = supabase, _ref = ref;

  Future<List<ChargesModele>> getAll({String? statut}) =>
      _db.chargesModelesDao.getAll(statut: statut);

  Future<ChargesModele?> getById(String id) =>
      _db.chargesModelesDao.getById(id);

  Future<List<ChargesModeleLine>> getLignes(String modeleId) =>
      _db.chargesModelesDao.getLignes(modeleId);

  Future<String> create(Map<String, dynamic> data, List<Map<String, dynamic>> lignes) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    // IDs générés à l'avance pour pouvoir synchroniser les lignes avec Supabase
    final ligneIds = List.generate(lignes.length, (_) => const Uuid().v4());

    await _db.transaction(() async {
      await _db.chargesModelesDao.upsert(ChargesModelesCompanion.insert(
        id: id,
        entrepriseId: data['entreprise_id'] as String? ?? '',
        mois: data['mois'] as int,
        annee: data['annee'] as int,
        titre: data['titre'] as String,
        soumisParId: drift.Value(data['soumis_par_id'] as String?),
        soumisParNom: drift.Value(data['soumis_par_nom'] as String?),
      ));

      for (var i = 0; i < lignes.length; i++) {
        final l = lignes[i];
        await _db.chargesModelesDao.upsertLigne(ChargesModeleLinesCompanion.insert(
          id: ligneIds[i],
          modeleId: id,
          ordre: drift.Value(i),
          designation: l['designation'] as String,
          montant: drift.Value((l['montant'] as num? ?? 0).toDouble()),
          dateEcheance: drift.Value(l['date_echeance'] as DateTime?),
          priorite: drift.Value(l['priorite'] as String? ?? 'normale'),
          notes: drift.Value(l['notes'] as String?),
        ));
      }
    });

    final syncData = {
      'id': id,
      'entreprise_id': data['entreprise_id'] as String? ?? '',
      'mois': data['mois'] as int,
      'annee': data['annee'] as int,
      'titre': data['titre'] as String,
      'soumis_par_id': data['soumis_par_id'] as String?,
      'soumis_par_nom': data['soumis_par_nom'] as String?,
      'statut': 'brouillon',
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    final lignesPayload = [
      for (var i = 0; i < lignes.length; i++)
        {
          'id': ligneIds[i],
          'modele_id': id,
          'ordre': i,
          'designation': lignes[i]['designation'] as String,
          'montant': (lignes[i]['montant'] as num? ?? 0).toDouble(),
          'date_echeance': (lignes[i]['date_echeance'] as DateTime?)?.toIso8601String(),
          'priorite': lignes[i]['priorite'] as String? ?? 'normale',
          'statut': 'pending',
          'notes': lignes[i]['notes'] as String?,
          'created_at': now.toIso8601String(),
        },
    ];

    if (_ref.read(isOnlineProvider)) {
      await _trySync(id, syncData, 'create');
      await _syncLignes(lignesPayload);
    } else {
      await _db.syncQueueDao.enqueue(entityType: 'charge_modele', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe(syncData)));
      if (lignesPayload.isNotEmpty) {
        await _db.syncQueueDao.enqueue(entityType: 'charges_modele_lines', entityId: id, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignesPayload})));
      }
    }
    return id;
  }

  Future<void> updateLignes(String modeleId, List<Map<String, dynamic>> lignes) async {
    await _db.chargesModelesDao.deleteLignes(modeleId);
    final now = DateTime.now();
    for (var i = 0; i < lignes.length; i++) {
      final l = lignes[i];
      await _db.chargesModelesDao.upsertLigne(ChargesModeleLinesCompanion.insert(
        id: l['id'] as String? ?? const Uuid().v4(),
        modeleId: modeleId,
        ordre: drift.Value(i),
        designation: l['designation'] as String,
        montant: drift.Value((l['montant'] as num? ?? 0).toDouble()),
        dateEcheance: drift.Value(l['date_echeance'] as DateTime?),
        priorite: drift.Value(l['priorite'] as String? ?? 'normale'),
        notes: drift.Value(l['notes'] as String?),
      ));
    }

    final lignesPayload = [
      for (var i = 0; i < lignes.length; i++)
        {
          'id': lignes[i]['id'] as String? ?? const Uuid().v4(),
          'modele_id': modeleId,
          'ordre': i,
          'designation': lignes[i]['designation'] as String,
          'montant': (lignes[i]['montant'] as num? ?? 0).toDouble(),
          'date_echeance': (lignes[i]['date_echeance'] as DateTime?)?.toIso8601String(),
          'priorite': lignes[i]['priorite'] as String? ?? 'normale',
          'statut': lignes[i]['statut'] as String? ?? 'pending',
          'notes': lignes[i]['notes'] as String?,
          'created_at': now.toIso8601String(),
        },
    ];

    await _syncLignesReplace(modeleId, lignesPayload);
  }

  Future<void> soumettre(String id) async {
    final now = DateTime.now();
    await _db.chargesModelesDao.updateStatut(id, 'soumis', dateSubmission: now);
    await _trySyncUpdate('charge_modele', 'charges_modeles', id, {
      'statut': 'soumis',
      'date_submission': now.toIso8601String(),
    });
  }

  Future<void> valider(String id, String userId, String userNom) async {
    final now = DateTime.now();
    await _db.chargesModelesDao.updateStatut(
      id, 'valide',
      dateValidation: now,
      valideParId: userId,
      valideParNom: userNom,
    );
    await _trySyncUpdate('charge_modele', 'charges_modeles', id, {
      'statut': 'valide',
      'date_validation': now.toIso8601String(),
      'valide_par_id': userId,
      'valide_par_nom': userNom,
    });
  }

  Future<void> refuser(String id, String motif, String userId, String userNom) async {
    final now = DateTime.now();
    await _db.chargesModelesDao.updateStatut(
      id, 'refuse',
      motifRefus: motif,
      dateValidation: now,
      valideParId: userId,
      valideParNom: userNom,
    );
    await _trySyncUpdate('charge_modele', 'charges_modeles', id, {
      'statut': 'refuse',
      'motif_refus': motif,
      'date_validation': now.toIso8601String(),
      'valide_par_id': userId,
      'valide_par_nom': userNom,
    });
  }

  Future<void> reporter(String id) async {
    await _db.chargesModelesDao.updateStatut(id, 'reporte');
    await _trySyncUpdate('charge_modele', 'charges_modeles', id, {'statut': 'reporte'});
  }

  Future<void> updateLigneStatut(String ligneId, String statut, {String? motif}) async {
    await _db.chargesModelesDao.updateLigneStatut(ligneId, statut, motifRefus: motif);
    await _trySyncUpdate('charges_modele_line', 'charges_modele_lines', ligneId, {
      'statut': statut,
      'motif_refus': motif,
    });
  }

  /// Pousse les lignes d'un nouveau modèle vers Supabase (table `charges_modele_lines`).
  Future<void> _syncLignes(List<Map<String, dynamic>> lignes) async {
    if (lignes.isEmpty) return;
    try {
      await _supabase.from('charges_modele_lines').upsert(lignes.map(toJsonSafe).toList());
    } catch (e, s) {
      AppLogger.e('ChargesModelesRepository', 'Échec sync lignes modèle', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'charges_modele_lines', entityId: lignes.first['modele_id'] as String, operation: 'create', payload: jsonEncode(toJsonSafe({'lignes': lignes})));
    }
  }

  /// Remplace entièrement les lignes d'un modèle dans Supabase (suppression + insertion).
  Future<void> _syncLignesReplace(String modeleId, List<Map<String, dynamic>> lignes) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from('charges_modele_lines').delete().eq('modele_id', modeleId);
        if (lignes.isNotEmpty) {
          await _supabase.from('charges_modele_lines').upsert(lignes.map(toJsonSafe).toList());
        }
        return;
      } catch (e, s) {
        AppLogger.e('ChargesModelesRepository', 'Échec sync lignes modèle $modeleId', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(
      entityType: 'charges_modele_lines',
      entityId: modeleId,
      operation: 'create',
      payload: jsonEncode(toJsonSafe({'lignes': lignes, 'replace_key': 'modele_id', 'replace_value': modeleId})),
    );
  }

  Future<void> _trySync(String id, Map<String, dynamic> data, String op) async {
    try {
      await _supabase.from('charges_modeles').insert(toJsonSafe(data));
      await _db.chargesModelesDao.markSynced(id);
      AppLogger.i('ChargesModelesRepository', 'Modèle de charges $id synchronisé avec Supabase');
    } catch (e, s) {
      AppLogger.e('ChargesModelesRepository', 'Échec sync Supabase modèle $id ($op)', error: e, stack: s);
      await _db.syncQueueDao.enqueue(entityType: 'charge_modele', entityId: id, operation: op, payload: jsonEncode(toJsonSafe({...data, 'id': id})));
    }
  }

  Future<void> _trySyncUpdate(String entityType, String table, String id, Map<String, dynamic> data) async {
    if (_ref.read(isOnlineProvider)) {
      try {
        await _supabase.from(table).update(toJsonSafe(data)).eq('id', id);
        if (entityType == 'charge_modele') await _db.chargesModelesDao.markSynced(id);
        return;
      } catch (e, s) {
        AppLogger.e('ChargesModelesRepository', 'Échec sync $entityType $id', error: e, stack: s);
      }
    }
    await _db.syncQueueDao.enqueue(entityType: entityType, entityId: id, operation: 'update', payload: jsonEncode(toJsonSafe({...data, 'id': id})));
  }
}
