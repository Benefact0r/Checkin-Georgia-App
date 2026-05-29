import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Checkin Georgia brand tokens.
///
/// Single source of truth for color. Mirrors the brand foundation doc.
/// Direction: bold · premium · modern · eager · high colour.
/// Signature: Checkin Violet → Eager Coral gradient.
abstract final class AppColors {
  AppColors._();

  // Primary — Checkin Violet
  static const violet50 = Color(0xFFF3EEFE);
  static const violet100 = Color(0xFFE4D9FD);
  static const violet200 = Color(0xFFC9B3FB);
  static const violet300 = Color(0xFFA985F7);
  static const violet400 = Color(0xFF8B5CF3);
  static const violet500 = Color(0xFF6D28E8); // base
  static const violet600 = Color(0xFF5A1FD0);
  static const violet700 = Color(0xFF4818A8);
  static const violet800 = Color(0xFF361280);
  static const violet900 = Color(0xFF240C54);

  // Accent — Eager Coral (CTAs, urgency)
  static const coral50 = Color(0xFFFFEAEF);
  static const coral100 = Color(0xFFFFD0DB);
  static const coral200 = Color(0xFFFFA3B8);
  static const coral300 = Color(0xFFFF7593);
  static const coral400 = Color(0xFFFF4D71);
  static const coral500 = Color(0xFFFF1E54); // base
  static const coral600 = Color(0xFFE50047);
  static const coral700 = Color(0xFFB80039);
  static const coral800 = Color(0xFF8A002B);
  static const coral900 = Color(0xFF5C001D);

  // Highlight — Signal Gold (ratings, premium tags)
  static const gold = Color(0xFFFFB020);

  // Neutrals — Ink (cool, faint violet tint)
  static const ink0 = Color(0xFFFFFFFF);
  static const ink50 = Color(0xFFF7F6FB);
  static const ink100 = Color(0xFFEFEDF5);
  static const ink200 = Color(0xFFDEDBE8);
  static const ink300 = Color(0xFFC2BDD2);
  static const ink400 = Color(0xFF9A93AE);
  static const ink500 = Color(0xFF726B86);
  static const ink600 = Color(0xFF524C63);
  static const ink700 = Color(0xFF383247);
  static const ink800 = Color(0xFF221E2E);
  static const ink900 = Color(0xFF14111C); // premium near-black surface

  // Semantic
  static const success = Color(0xFF00C2A8);
  static const warning = gold;
  static const error = coral500;
  static const info = violet500;

  /// Signature brand gradient (135°): violet → coral.
  static const sunset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet500, coral500],
  );
}

abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.violet500,
      onPrimary: AppColors.ink0,
      primaryContainer: AppColors.violet100,
      onPrimaryContainer: AppColors.violet900,
      secondary: AppColors.coral500,
      onSecondary: AppColors.ink0,
      secondaryContainer: AppColors.coral100,
      onSecondaryContainer: AppColors.coral900,
      tertiary: AppColors.gold,
      onTertiary: AppColors.ink900,
      error: AppColors.error,
      onError: AppColors.ink0,
      surface: AppColors.ink0,
      onSurface: AppColors.ink900,
      surfaceContainerHighest: AppColors.ink100,
      onSurfaceVariant: AppColors.ink600,
      outline: AppColors.ink300,
      outlineVariant: AppColors.ink200,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ink50,
      textTheme: GoogleFonts.notoSansGeorgianTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink900,
        displayColor: AppColors.ink900,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.violet500,
        foregroundColor: AppColors.ink0,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.ink0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.ink200),
        ),
      ),
      // Primary actions are the eager coral CTA.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.coral500,
          foregroundColor: AppColors.ink0,
          textStyle: GoogleFonts.notoSansGeorgian(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.violet500,
        backgroundColor: AppColors.ink100,
        labelStyle: const TextStyle(color: AppColors.ink800),
        secondaryLabelStyle: const TextStyle(color: AppColors.ink0),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.violet400,
      onPrimary: AppColors.ink0,
      primaryContainer: AppColors.violet800,
      onPrimaryContainer: AppColors.violet100,
      secondary: AppColors.coral400,
      onSecondary: AppColors.ink0,
      secondaryContainer: AppColors.coral800,
      onSecondaryContainer: AppColors.coral100,
      tertiary: AppColors.gold,
      onTertiary: AppColors.ink900,
      error: AppColors.coral400,
      onError: AppColors.ink0,
      surface: AppColors.ink900,
      onSurface: AppColors.ink50,
      surfaceContainerHighest: AppColors.ink800,
      onSurfaceVariant: AppColors.ink300,
      outline: AppColors.ink700,
      outlineVariant: AppColors.ink800,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ink900,
      textTheme: GoogleFonts.notoSansGeorgianTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink50,
        displayColor: AppColors.ink50,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ink900,
        foregroundColor: AppColors.ink50,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.ink800,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.ink700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.coral500,
          foregroundColor: AppColors.ink0,
          textStyle: GoogleFonts.notoSansGeorgian(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.violet500,
        backgroundColor: AppColors.ink800,
        labelStyle: const TextStyle(color: AppColors.ink100),
        secondaryLabelStyle: const TextStyle(color: AppColors.ink0),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

