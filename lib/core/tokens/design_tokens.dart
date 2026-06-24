// Single source of truth for visual design decisions.
// Screens and widgets import from here instead of hardcoding values.

import 'package:flutter/material.dart';

// ── Colors ────────────────────────────────────────────────────────────────────

abstract class Clr {
  // ── Brand ────────────────────────────────────────────────────────────
  // Bangladesh Green — kept for brand identity (income, FAB, checkmarks)
  static const accent = Color(0xFF006A4E);
  static const accentLight = Color(0xFF00A878);
  static const accentDim = Color(0xFF004D38);
  static const accentContainer = Color(0xFFD6F0E8);

  // ── Cool light surfaces ───────────────────────────────────────────────
  static const coolBg   = Color(0xFFF0F5FF);   // ice-blue scaffold
  static const coolCard = Color(0xFFFFFFFF);   // crisp white card
  static const coolElevated = Color(0xFFE4EDFB); // slightly deeper surface

  // ── Hero balance card — cobalt / indigo ───────────────────────────────
  static const heroBlue     = Color(0xFF1D4ED8); // cobalt blue
  static const heroBlueMid  = Color(0xFF2563EB); // bright blue
  static const heroBlueDeep = Color(0xFF1E3A8A); // deep navy
  static const heroOnBlue   = Color(0xFFFFFFFF); // white text on blue

  // ── Dark surfaces — deep navy family ─────────────────────────────────
  static const darkBg      = Color(0xFF060B14); // deep navy-black
  static const darkCard    = Color(0xFF0F1829); // navy card
  static const darkCardAlt = Color(0xFF162033); // slightly lighter
  static const darkSep     = Color(0xFF1E2D45); // separator

  // ── Semantic ─────────────────────────────────────────────────────────
  static const income  = Color(0xFF22C55E); // fresh green
  static const expense = Color(0xFFEF4444); // crisp red
  static const warning = Color(0xFFF59E0B); // amber
  static const info    = Color(0xFF3B82F6); // sky blue

  // ── Text — slate scale (cooler than iOS gray) ─────────────────────────
  static const textDark  = Color(0xFF0F172A); // slate-900
  static const textMid   = Color(0xFF64748B); // slate-500
  static const textLight = Color(0xFFCBD5E1); // slate-300

  // ── Nav active pill ───────────────────────────────────────────────────
  static const navPillLight = Color(0xFF1D4ED8); // cobalt pill in light mode
  static const navPillDark  = Color(0xFF6366F1); // indigo pill in dark mode

  // ── Backward compat aliases (warmBg still referenced in app_colors.dart)
  static const warmBg   = coolBg;
  static const warmCard = coolCard;
}

// ── Spacing ───────────────────────────────────────────────────────────────────

abstract class Spc {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  // Layout
  static const screen = 20.0;   // horizontal screen padding
  static const section = 20.0;  // vertical gap between sections
  static const card = 18.0;     // inner card padding
}

// ── Radii ─────────────────────────────────────────────────────────────────────

abstract class Rad {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 22.0;
  static const hero = 26.0;
  static const full = 100.0;
}

// ── Shadows ───────────────────────────────────────────────────────────────────

abstract class Shd {
  static List<BoxShadow> card(bool isDark) => isDark
      ? []
      : [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.055),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ];

  static List<BoxShadow> subtle(bool isDark) => isDark
      ? []
      : [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ];
}

// ── Typography — iOS HIG (SF Pro / Roboto) ───────────────────────────────────
// Letter-spacing values are converted from Apple's tracking units:
//   px = (tracking / 1000) × fontSize   (positive = wider, negative = tighter)
// Large text uses positive tracking; body/headline ranges use negative.

abstract class Tx {
  // ── Display — hero net worth (non-HIG, custom for finance readout) ────
  static const display = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    height: 1.05,
  );

  // ── iOS HIG named styles ──────────────────────────────────────────────

  // Large Title  34pt  Regular
  static const largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    height: 1.21,
  );

  // Title 1  28pt  Regular
  static const title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.21,
  );

  // Title 2  22pt  Semibold
  static const title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  // Title 3  20pt  Regular
  static const title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  // Headline  17pt  Semibold
  static const headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.29,
  );

  // Body  17pt  Regular
  static const iosBody = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.29,
  );

  // Callout  16pt  Regular
  static const callout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.31,
  );

  // Subheadline  15pt  Regular
  static const subhead = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  // Footnote  13pt  Regular
  static const footnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.38,
  );

  // Caption 1  12pt  Regular
  static const caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  // Caption 2  11pt  Regular
  static const caption2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.18,
  );

  // ── Backward-compat aliases ───────────────────────────────────────────
  static const h1      = title2;
  static const h2      = headline;
  static const h3      = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.33);
  static const body    = subhead;
  static const bodyMed = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.33);
  static const caption = caption1;
  static const label   = caption2;
  static const micro   = caption2;
}

// ── Liquid Glass tokens ───────────────────────────────────────────────────────

abstract class Glass {
  // Blur intensities
  static const sigmaCard = 0.0;   // cards in lists: static-glass (no blur cost)
  static const sigmaNav  = 44.0;  // floating nav bar
  static const sigmaModal= 32.0;  // modals, sheets

  // Fill — light mode
  static const fillLight     = Color(0x9FFFFFFF); // 62% white
  static const fillLightDeep = Color(0xBFFFFFFF); // 75% white

  // Fill — dark mode  (navy glass)
  static const fillDark     = Color(0x14FFFFFF);  // 8% white
  static const fillDarkDeep = Color(0x1EFFFFFF);  // 12% white

  // Specular edge highlight
  static const specLight = Color(0xCCFFFFFF); // 80% white top strip (light)
  static const specDark  = Color(0x1AFFFFFF); // 10% white top strip (dark)

  // Border
  static const borderLight = Color(0xB3FFFFFF); // 70% white
  static const borderDark  = Color(0x1AFFFFFF); // 10% white
}
