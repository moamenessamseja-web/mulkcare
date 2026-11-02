import 'package:flutter/material.dart';

import 'tokens.dart';

class AppText {
  static const family = 'Tajawal';
  static const display = TextStyle(fontFamily: family, fontSize: 32, fontWeight: FontWeight.w700, height: 1.35, color: AppColors.text);
  static const h1 = TextStyle(fontFamily: family, fontSize: 26, fontWeight: FontWeight.w700, height: 1.4, color: AppColors.text);
  static const h2 = TextStyle(fontFamily: family, fontSize: 22, fontWeight: FontWeight.w700, height: 1.45, color: AppColors.text);
  static const h3 = TextStyle(fontFamily: family, fontSize: 18, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.text);
  static const body = TextStyle(fontFamily: family, fontSize: 16, fontWeight: FontWeight.w400, height: 1.8, color: AppColors.text);
  static const label = TextStyle(fontFamily: family, fontSize: 14, fontWeight: FontWeight.w500, height: 1.6, color: AppColors.text);
  static const caption = TextStyle(fontFamily: family, fontSize: 13, fontWeight: FontWeight.w400, height: 1.7, color: AppColors.onSurfaceMuted);
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
  OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: color, width: width),
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
      toolbarHeight: AppSpace.appBar,
      titleTextStyle: TextStyle(fontFamily: AppText.family, fontSize: 18, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.primary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
      border: border(AppColors.border, 1),
      enabledBorder: border(AppColors.border, 1),
      focusedBorder: border(AppColors.secondary, 2),
      errorBorder: border(AppColors.danger, 1),
      focusedErrorBorder: border(AppColors.danger, 2),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, AppSpace.touchMin),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        textStyle: AppText.label,
        side: const BorderSide(color: AppColors.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: AppSpace.bottomNav,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primaryTint,
      indicatorShape: const StadiumBorder(),
      labelTextStyle: WidgetStateProperty.all(AppText.caption),
    ),
    dividerColor: AppColors.border,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceInverse,
      contentTextStyle: AppText.label.copyWith(color: AppColors.onBrand),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    ),
  );
}
