import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String statut;
  const StatusBadge({super.key, required this.statut});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withAlpha(100)),
      ),
      child: Text(
        AppConstants.statutLabels[statut] ?? statut,
        style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color get _color {
    switch (statut) {
      case AppConstants.statutBrouillon: return AppColors.statutBrouillon;
      case AppConstants.statutEnInstruction: return AppColors.statutEnInstruction;
      case AppConstants.statutEnCours: return AppColors.statutEnCours;
      case AppConstants.statutTermine: return AppColors.statutTermine;
      case AppConstants.statutAnnule: return AppColors.statutAnnule;
      default: return Colors.grey;
    }
  }
}

class PrioriteBadge extends StatelessWidget {
  final String priorite;
  const PrioriteBadge({super.key, required this.priorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _color),
          const SizedBox(width: 4),
          Text(
            AppConstants.prioriteLabels[priorite] ?? priorite,
            style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Color get _color {
    switch (priorite) {
      case AppConstants.prioriteBasse: return AppColors.prioriteBasse;
      case AppConstants.prioriteNormale: return AppColors.prioriteNormale;
      case AppConstants.prioriteHaute: return AppColors.prioriteHaute;
      case AppConstants.prioriteUrgente: return AppColors.prioriteUrgente;
      default: return Colors.grey;
    }
  }

  IconData get _icon {
    switch (priorite) {
      case AppConstants.prioriteUrgente: return Icons.priority_high;
      case AppConstants.prioriteHaute: return Icons.arrow_upward;
      case AppConstants.prioriteBasse: return Icons.arrow_downward;
      default: return Icons.remove;
    }
  }
}

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.syncPending,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'LOCAL',
        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
