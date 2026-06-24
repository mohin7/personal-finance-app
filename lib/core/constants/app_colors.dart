import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand — Bangladesh Green ───────────────────────────────────────────
  static const Color accent = Color(0xFF006A4E);
  static const Color accentLight = Color(0xFF00A878);
  static const Color accentDim = Color(0xFF004D38);
  static const Color accentContainer = Color(0xFFD6F0E8);

  // Legacy aliases
  static const Color primary = accent;
  static const Color primaryLight = accentLight;
  static const Color primaryDark = accentDim;
  static const Color primaryContainer = accentContainer;

  // ── Semantic ────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);  // fresh green
  static const Color error   = Color(0xFFEF4444);  // crisp red
  static const Color warning = Color(0xFFF59E0B);  // amber
  static const Color info    = Color(0xFF3B82F6);  // sky blue

  // ── Dark palette — deep navy ─────────────────────────────────────────
  static const Color ink       = Color(0xFF060B14); // deep navy-black
  static const Color inkRaised = Color(0xFF0F1829); // navy elevated
  static const Color inkHigh   = Color(0xFF162033); // higher surface
  static const Color inkPanel  = Color(0xFF1E2D45); // panel/card

  // ── Light palette — cool blue-tinted ─────────────────────────────────
  static const Color warmBg = Color(0xFFF0F5FF);   // ice-blue scaffold
  static const Color chalk  = Color(0xFFE4EDFB);   // cool elevated
  static const Color snow   = Color(0xFFFFFFFF);   // card surface
  static const Color fog    = Color(0xFFE2EAF8);   // cool separator/divider

  // ── Surface aliases ────────────────────────────────────────────────────
  static const Color backgroundLight      = warmBg;
  static const Color backgroundDark       = ink;
  static const Color surfaceLight         = snow;
  static const Color surfaceDark          = inkRaised;
  static const Color surfaceVariantDark   = inkHigh;
  static const Color surfaceVariantLight  = chalk;
  static const Color cardLight            = snow;
  static const Color cardDark             = inkRaised;
  static const Color separator            = fog;
  static const Color separatorDark        = Color(0xFF1E2D45);

  // ── Red accent aliases ─────────────────────────────────────────────────
  static const Color accentRed      = Color(0xFFEF4444);
  static const Color accentRedLight = Color(0xFFFCA5A5);

  // ── Text — slate scale ─────────────────────────────────────────────────
  static const Color textPrimary      = Color(0xFF0F172A); // slate-900
  static const Color textSecondary    = Color(0xFF64748B); // slate-500
  static const Color textTertiary     = Color(0xFFCBD5E1); // slate-300
  static const Color textPrimaryDark  = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF94A3B8); // slate-400

  // ── Chart palette ──────────────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF2563EB), // blue
    Color(0xFF006A4E), // Bangladesh green
    Color(0xFF22C55E), // fresh green
    Color(0xFFEF4444), // red
    Color(0xFFF59E0B), // amber
    Color(0xFF8B5CF6), // violet
    Color(0xFFEC4899), // pink
    Color(0xFF06B6D4), // cyan
  ];

  // ── Gradients ──────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF0F1829), Color(0xFF162033)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
