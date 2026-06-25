import 'package:flutter/cupertino.dart';

class AppIcons {
  AppIcons._();

  // ── Bottom nav ──────────────────────────────────────────────────────
  static const dashboard   = CupertinoIcons.house_fill;
  static const expenses    = CupertinoIcons.arrow_down_circle_fill;
  static const income      = CupertinoIcons.arrow_up_circle_fill;
  static const investments = CupertinoIcons.chart_pie_fill;
  static const more        = CupertinoIcons.ellipsis_circle_fill;

  // ── Finance ─────────────────────────────────────────────────────────
  static const wallet        = CupertinoIcons.creditcard_fill;
  static const cash          = CupertinoIcons.money_dollar_circle;
  static const bank          = CupertinoIcons.building_2_fill;
  static const dps           = CupertinoIcons.archivebox_fill;
  static const fdr           = CupertinoIcons.lock_fill;
  static const sanchayapatra = CupertinoIcons.doc_fill;
  static const budget        = CupertinoIcons.chart_pie_fill;
  static const reports       = CupertinoIcons.chart_bar_circle_fill;
  static const settings      = CupertinoIcons.gear;
  static const netWorth      = CupertinoIcons.arrow_up_circle_fill;

  // ── Actions ─────────────────────────────────────────────────────────
  static const loan         = CupertinoIcons.person_2_fill;
  static const add          = CupertinoIcons.plus_circle_fill;
  static const edit         = CupertinoIcons.pencil;
  static const delete       = CupertinoIcons.trash_fill;
  static const search       = CupertinoIcons.search;
  static const filter       = CupertinoIcons.slider_horizontal_3;
  static const close        = CupertinoIcons.xmark_circle_fill;
  static const check        = CupertinoIcons.checkmark_circle_fill;
  static const calendar     = CupertinoIcons.calendar;
  static const notification = CupertinoIcons.bell_fill;
  static const share        = CupertinoIcons.share;
  static const download     = CupertinoIcons.arrow_down_circle_fill;
  static const back         = CupertinoIcons.arrow_left;

  // ── Status / Security ───────────────────────────────────────────────
  static const lock      = CupertinoIcons.lock_fill;
  static const biometric = CupertinoIcons.hand_draw;
  static const profit    = CupertinoIcons.arrow_up_circle_fill;
  static const loss      = CupertinoIcons.arrow_down_circle_fill;

  // ── Category icons ───────────────────────────────────────────────────
  static const categoryFood          = CupertinoIcons.cart_fill;
  static const categoryTransport     = CupertinoIcons.car_fill;
  static const categoryRent          = CupertinoIcons.house_fill;
  static const categoryUtilities     = CupertinoIcons.bolt_fill;
  static const categoryShopping      = CupertinoIcons.bag_fill;
  static const categoryMobile        = CupertinoIcons.phone_fill;
  static const categoryInternet      = CupertinoIcons.wifi;
  static const categoryMedical       = CupertinoIcons.heart_fill;
  static const categoryEducation     = CupertinoIcons.book_fill;
  static const categoryFamily        = CupertinoIcons.person_2_fill;
  static const categoryEntertainment = CupertinoIcons.gamecontroller_fill;
  static const categoryTravel        = CupertinoIcons.airplane;
  static const categoryOther         = CupertinoIcons.square_grid_2x2_fill;

  static IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':              return categoryFood;
      case 'transport':         return categoryTransport;
      case 'rent':              return categoryRent;
      case 'utilities':         return categoryUtilities;
      case 'shopping':          return categoryShopping;
      case 'mobile recharge':   return categoryMobile;
      case 'internet':          return categoryInternet;
      case 'medical':           return categoryMedical;
      case 'education':         return categoryEducation;
      case 'family':            return categoryFamily;
      case 'entertainment':     return categoryEntertainment;
      case 'travel':            return categoryTravel;
      default:                  return categoryOther;
    }
  }

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':              return const Color(0xFFFF9500); // orange
      case 'transport':         return const Color(0xFF007AFF); // blue
      case 'rent':              return const Color(0xFF5856D6); // purple
      case 'utilities':         return const Color(0xFFFFCC00); // yellow
      case 'shopping':          return const Color(0xFFFF2D55); // pink
      case 'mobile recharge':   return const Color(0xFF34C759); // green
      case 'internet':          return const Color(0xFF5AC8FA); // teal
      case 'medical':           return const Color(0xFFFF3B30); // red
      case 'education':         return const Color(0xFF007AFF); // blue
      case 'family':            return const Color(0xFF5856D6); // purple
      case 'entertainment':     return const Color(0xFFFF9500); // orange
      case 'travel':            return const Color(0xFF34C759); // green
      default:                  return const Color(0xFF8E8E93); // systemGray
    }
  }
}
