import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Bangladesh palette ──────────────────────────────────────────────
  static const Color primary = Color(0xFF006A4E);
  static const Color primaryLight = Color(0xFF00A878);
  static const Color primaryDark = Color(0xFF004D38);
  static const Color primaryContainer = Color(0xFFD6F0E8);

  static const Color accent = Color(0xFFF42A41);
  static const Color accentLight = Color(0xFFFF6B7A);
  static const Color accentContainer = Color(0xFFFFE8EB);

  // ── Surfaces ────────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF2F2F7);
  static const Color backgroundDark = Color(0xFF000000);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2E);
  static const Color surfaceVariantLight = Color(0xFFF2F2F7);

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1C1C1E);

  // ── Text ────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);

  // ── Semantic ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // ── Chart palette ───────────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF006A4E),
    Color(0xFF00A878),
    Color(0xFFF42A41),
    Color(0xFFFF9500),
    Color(0xFF007AFF),
    Color(0xFF5856D6),
    Color(0xFFFF2D55),
    Color(0xFFAF52DE),
  ];

  // ── Gradients ───────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF006A4E), Color(0xFF00A878)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF42A41), Color(0xFFFF6B7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1C1C1E), Color(0xFF2C2C2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Separator ───────────────────────────────────────────────────────
  static const Color separator = Color(0xFFC6C6C8);
  static const Color separatorDark = Color(0xFF38383A);
}
