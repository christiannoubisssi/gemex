import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Overlay semi-transparent affiché par-dessus un écran pendant une opération asynchrone.
///
/// Utilisation :
/// ```dart
/// return SaveOverlay(
///   saving: _saving,
///   label: 'Création du dossier…',
///   child: Scaffold(...),
/// );
/// ```
class SaveOverlay extends StatelessWidget {
  final Widget child;
  final bool saving;
  final String label;

  const SaveOverlay({
    super.key,
    required this.child,
    required this.saving,
    this.label = 'Enregistrement en cours…',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bloque les interactions utilisateur pendant la sauvegarde
        AbsorbPointer(absorbing: saving, child: child),

        if (saving) ...[
          // Fond sombre
          const ModalBarrier(dismissible: false, color: Colors.black54),

          // Carte centrale
          Center(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Veuillez patienter…',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
