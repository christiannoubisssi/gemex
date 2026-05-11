import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        // Typographie Inter (Spec DESIGN.md)
        textTheme: GoogleFonts.interTextTheme(),
        
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.slate,
          onSecondary: Colors.white,
          error: AppColors.danger,
          onError: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.surfaceVariant,
          outline: Color(0xFFCBD5E1),
          outlineVariant: AppColors.borderLight,
        ),
        
        scaffoldBackgroundColor: AppColors.pageBg,
        
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.navy,
          elevation: 0,
          centerTitle: false,
          shape: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Sidebar (Navigation latérale Spec DESIGN.md)
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: AppColors.navy,
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white60),
          selectedLabelTextStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelTextStyle: TextStyle(color: Colors.white60, fontSize: 12),
          indicatorColor: AppColors.primary,
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.navy,
          scrimColor: Colors.black54,
        ),
        
        // Cartes (Niveau 1 Spec DESIGN.md)
        cardTheme: CardThemeData(
          elevation: 0,
          shadowColor: Colors.black.withAlpha(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rayon 8px (lg)
            side: const BorderSide(color: AppColors.borderLight, width: 1),
          ),
          color: Colors.white,
        ),
        
        // Boutons (Rayon 4px Spec DESIGN.md)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // Rayon 4px (sm/md)
            elevation: 0,
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.slate,
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: Color(0xFFCBD5E1)),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
        
        // Champs de saisie (Spec DESIGN.md)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.danger),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)), // Pill-shaped
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          backgroundColor: AppColors.surfaceVariant,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        
        dividerTheme: const DividerThemeData(
          color: AppColors.borderLight,
          thickness: 1,
        ),
        
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );

  static const Color danger = AppColors.danger;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
}
