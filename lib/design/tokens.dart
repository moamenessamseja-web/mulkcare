import 'package:flutter/material.dart';

/// MulkCare design tokens; source of truth is DESIGN.md.
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
  static const scrim = Color(0x8C084A6F);
  static const chart4 = Color(0xFFD07A4E);
  static const chart5 = Color(0xFF6B7A8F);
  static const chartGridline = Color(0xFFE6EBF1);
  static const chartTrack = Color(0xFFEDF1F6);
}

class AppRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double full = 9999;
}

class AppSpace {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
  static const double gutter = 16;
  static const double screen = 20;
  static const double appBar = 56;
  static const double bottomNav = 64;
  static const double actionRow = 72;
  static const double touchMin = 44;
  static const double phoneWidth = 390;
  static const double appColumnMax = 480;
}

const raisedShadow = <BoxShadow>[
  BoxShadow(color: Color(0x0D082A40), blurRadius: 2, offset: Offset(0, 1)),
  BoxShadow(
    color: Color(0x24082A40),
    blurRadius: 20,
    spreadRadius: -12,
    offset: Offset(0, 8),
  ),
];
