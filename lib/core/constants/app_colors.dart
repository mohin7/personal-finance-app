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

  // ── Semantic — Apple HIG dark mode system colors ────────────────────────
  static const Color success = Color(0xFF30D158); // systemGreen (dark)
  static const Color error   = Color(0xFFFF453A); // systemRed (dark)
  static const Color warning = Color(0xFFFF9F0A); // systemOrange (dark)
  static const Color info    = Color(0xFF0A84FF); // systemBlue (dark)

  // ── Dark palette — soft charcoal (lifted from pure black) ────────────
  static const Color ink       = Color(0xFF141414); // soft black scaffold
  static const Color inkRaised = Color(0xFF1E1E1E); // card surface
  static const Color inkHigh   = Color(0xFF282828); // elevated surface
  static const Color inkPanel  = Color(0xFF333333); // top-elevated surface

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
  static const Color separatorDark        = Color(0xFF3A3A3A); // soft separator

  // ── Red accent aliases ─────────────────────────────────────────────────
  static const Color accentRed      = Color(0xFFEF4444);
  static const Color accentRedLight = Color(0xFFFCA5A5);

  // ── Text — slate scale ─────────────────────────────────────────────────
  static const Color textPrimary      = Color(0xFF0F172A); // slate-900
  static const Color textSecondary    = Color(0xFF64748B); // slate-500
  static const Color textTertiary     = Color(0xFFCBD5E1); // slate-300
  static const Color textPrimaryDark  = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF94A3B8); // slate-400

  // ── Chart palette — Apple HIG dark mode system colors ─────────────────
  static const List<Color> chartColors = [
    Color(0xFF0A84FF), // systemBlue
    Color(0xFF30D158), // systemGreen (Bangladesh brand)
    Color(0xFFFF9F0A), // systemOrange
    Color(0xFFFF453A), // systemRed
    Color(0xFFBF5AF2), // systemPurple
    Color(0xFF5E5CE6), // systemIndigo
    Color(0xFFFF375F), // systemPink
    Color(0xFF5AC8FA), // systemTeal/Cyan
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
