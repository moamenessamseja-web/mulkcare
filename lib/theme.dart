import 'package:flutter/material.dart';

/// Design tokens copied from /DESIGN.md (normative). Do not change values here
/// without changing DESIGN.md first.
class AppColors {
  static const primary = Color(0xFF084A6F);
  static const primaryStrong = Color(0xFF063A55);
  static const primaryTint = Color(0xFFE4EEF4);
  static const secondary = Color(0xFF00A3A3);
  static const secondaryStrong = Color(0xFF0A6E75);
  static const secondaryTint = Color(0xFFDFF3F3);
  static const accent = Color(0xFFF4B400);
  static const accentStrong = Color(0xFF8A6400);
  static const accentTint = Color(0xFFFDF1D4);
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFEDF1F6);
  static const surfaceInverse = Color(0xFF072F47);
  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);
  static const text = Color(0xFF1E293B);
  static const onSurfaceMuted = Color(0xFF55657A);
  static const onBrand = Color(0xFFFFFFFF);
  static const disabledSurface = Color(0xFFE9EEF3);
  static const disabledText = Color(0xFF98A4B3);
  static const success = Color(0xFF157347);
  static const successTint = Color(0xFFE6F4EC);
  static const warning = Color(0xFF9A5B00);
  static const warningTint = Color(0xFFFBEEDA);
  static const danger = Color(0xFFB3261E);
  static const dangerTint = Color(0xFFFBE9E7);
  static const focusRing = Color(0xFF00A3A3);
  // rgba(8, 74, 111, 0.55)
  static const scrim = Color(0x8C084A6F);
}

class AppRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
}

class AppSpace {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double gutter = 16;
  static const double screen = 20;
  static const double appBar = 56;
  static const double bottomNav = 64;
  static const double actionRow = 72;
  static const double touchMin = 44;
}

const List<BoxShadow> raisedShadow = [
  BoxShadow(color: Color(0x0D082A40), blurRadius: 2, offset: Offset(0, 1)),
  BoxShadow(
      color: Color(0x24082A40),
      blurRadius: 20,
      spreadRadius: -12,
      offset: Offset(0, 8)),
];

/// Typography scale from DESIGN.md. No letter-spacing, no italics.
class AppText {
  static const String family = 'Tajawal';
  static const display = TextStyle(
      fontFamily: family,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.35,
      letterSpacing: 0,
      color: AppColors.text);
  static const h1 = TextStyle(
      fontFamily: family,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.4,
      letterSpacing: 0,
      color: AppColors.text);
  static const h2 = TextStyle(
      fontFamily: family,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.45,
      letterSpacing: 0,
      color: AppColors.text);
  static const h3 = TextStyle(
      fontFamily: family,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0,
      color: AppColors.text);
  static const body = TextStyle(
      fontFamily: family,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.8,
      letterSpacing: 0,
      color: AppColors.text);
  static const label = TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.6,
      letterSpacing: 0,
      color: AppColors.text);
  static const caption = TextStyle(
      fontFamily: family,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.7,
      letterSpacing: 0,
      color: AppColors.onSurfaceMuted);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.onBrand,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    error: AppColors.danger,
    outline: AppColors.border,
  );
  OutlineInputBorder inputBorder(Color c, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: c, width: w),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: AppText.family,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(
      displayLarge: AppText.display,
      headlineLarge: AppText.h1,
      headlineMedium: AppText.h2,
      titleLarge: AppText.h3,
      titleMedium: AppText.h3,
      bodyLarge: AppText.body,
      bodyMedium: AppText.body,
      bodySmall: AppText.caption,
      labelLarge: AppText.label,
      labelMedium: AppText.label,
      labelSmall: AppText.caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: AppSpace.appBar,
      titleTextStyle: TextStyle(
          fontFamily: AppText.family,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0,
          color: AppColors.primary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md, vertical: AppSpace.sm),
      border: inputBorder(AppColors.border, 1),
      enabledBorder: inputBorder(AppColors.border, 1),
      focusedBorder: inputBorder(AppColors.secondary, 2),
      errorBorder: inputBorder(AppColors.danger, 1),
      focusedErrorBorder: inputBorder(AppColors.danger, 2),
      labelStyle: AppText.label.copyWith(color: AppColors.onSurfaceMuted),
      hintStyle: AppText.body.copyWith(color: AppColors.onSurfaceMuted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onBrand,
        disabledBackgroundColor: AppColors.disabledSurface,
        disabledForegroundColor: AppColors.disabledText,
        minimumSize: const Size(0, AppSpace.touchMin),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        textStyle: AppText.label,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, AppSpace.touchMin),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        textStyle: AppText.label,
        side: const BorderSide(color: AppColors.borderStrong),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: AppSpace.bottomNav,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primaryTint,
      indicatorShape: const StadiumBorder(),
      labelTextStyle: WidgetStateProperty.all(AppText.label),
    ),
    dividerColor: AppColors.border,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceInverse,
      contentTextStyle:
          AppText.label.copyWith(color: AppColors.onBrand),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
    ),
  );
}
