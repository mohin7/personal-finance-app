import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._();

  // ── Bottom nav ──────────────────────────────────────────────────────
  static const dashboard = CupertinoIcons.house_fill;
  static const expenses = CupertinoIcons.arrow_up_circle_fill;
  static const income = CupertinoIcons.arrow_down_circle_fill;
  static const investments = CupertinoIcons.chart_bar_fill;
  static const more = CupertinoIcons.ellipsis_circle_fill;

  // ── Finance ─────────────────────────────────────────────────────────
  static const wallet = CupertinoIcons.creditcard_fill;
  static const cash = CupertinoIcons.money_dollar_circle_fill;
  static const bank = CupertinoIcons.building_2_fill;
  static const dps = CupertinoIcons.calendar_badge_plus;
  static const fdr = CupertinoIcons.lock_fill;
  static const sanchayapatra = CupertinoIcons.doc_text_fill;
  static const budget = CupertinoIcons.chart_pie_fill;
  static const reports = CupertinoIcons.chart_bar_square_fill;
  static const settings = CupertinoIcons.gear_alt_fill;
  static const netWorth = CupertinoIcons.chart_bar_fill;

  // ── Actions ─────────────────────────────────────────────────────────
  static const add = CupertinoIcons.add_circled_solid;
  static const edit = CupertinoIcons.pencil;
  static const delete = CupertinoIcons.trash_fill;
  static const search = CupertinoIcons.search;
  static const filter = CupertinoIcons.slider_horizontal_3;
  static const back = CupertinoIcons.chevron_back;
  static const close = CupertinoIcons.xmark_circle_fill;
  static const check = CupertinoIcons.checkmark_circle_fill;
  static const calendar = CupertinoIcons.calendar;
  static const notification = CupertinoIcons.bell_fill;
  static const share = CupertinoIcons.share;
  static const download = CupertinoIcons.arrow_down_to_line;

  // ── Category icons ───────────────────────────────────────────────────
  static const categoryFood = CupertinoIcons.cart_fill;
  static const categoryTransport = CupertinoIcons.car_fill;
  static const categoryRent = CupertinoIcons.house_fill;
  static const categoryUtilities = CupertinoIcons.bolt_fill;
  static const categoryShopping = CupertinoIcons.bag_fill;
  static const categoryMobile = CupertinoIcons.device_phone_portrait;
  static const categoryInternet = CupertinoIcons.wifi;
  static const categoryMedical = CupertinoIcons.heart_fill;
  static const categoryEducation = CupertinoIcons.book_fill;
  static const categoryFamily = CupertinoIcons.person_2_fill;
  static const categoryEntertainment = CupertinoIcons.film_fill;
  static const categoryTravel = CupertinoIcons.airplane;
  static const categoryOther = CupertinoIcons.ellipsis_circle_fill;

  // ── Status ──────────────────────────────────────────────────────────
  static const profit = Icons.trending_up_rounded;
  static const loss = Icons.trending_down_rounded;
  static const neutral = Icons.trending_flat_rounded;
  static const lock = CupertinoIcons.lock_fill;
  static const biometric = Icons.fingerprint;
  static const pin = CupertinoIcons.number_circle_fill;

  static IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return categoryFood;
      case 'transport':
        return categoryTransport;
      case 'rent':
        return categoryRent;
      case 'utilities':
        return categoryUtilities;
      case 'shopping':
        return categoryShopping;
      case 'mobile recharge':
        return categoryMobile;
      case 'internet':
        return categoryInternet;
      case 'medical':
        return categoryMedical;
      case 'education':
        return categoryEducation;
      case 'family':
        return categoryFamily;
      case 'entertainment':
        return categoryEntertainment;
      case 'travel':
        return categoryTravel;
      default:
        return categoryOther;
    }
  }
}
