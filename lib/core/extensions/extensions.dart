import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

// ── Currency ─────────────────────────────────────────────────────────────────

extension CurrencyExt on double {
  String get taka {
    final f = NumberFormat('#,##,###.##', 'en_IN');
    return '৳${f.format(this)}';
  }

  String get takaCompact {
    if (this >= 10000000) return '৳${(this / 10000000).toStringAsFixed(2)} Cr';
    if (this >= 100000) return '৳${(this / 100000).toStringAsFixed(2)} L';
    if (this >= 1000) return '৳${(this / 1000).toStringAsFixed(1)}K';
    return taka;
  }

  String get takaSign {
    final formatted = taka;
    return this >= 0 ? '+$formatted' : formatted;
  }

  Color get profitLossColor =>
      this >= 0 ? AppColors.success : AppColors.error;

  String get percentFormatted => '${toStringAsFixed(1)}%';
}

// ── DateTime ──────────────────────────────────────────────────────────────────

extension DateTimeExt on DateTime {
  String get displayDate => DateFormat('d MMM yyyy').format(this);
  String get displayDateShort => DateFormat('d MMM').format(this);
  String get displayMonth => DateFormat('MMMM yyyy').format(this);
  String get displayMonthShort => DateFormat('MMM yy').format(this);
  String get displayTime => DateFormat('h:mm a').format(this);
  String get displayFull => DateFormat('d MMM yyyy, h:mm a').format(this);
  String get isoDate => DateFormat('yyyy-MM-dd').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  String get relativeDisplay {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return displayDate;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  int get daysUntil => difference(DateTime.now()).inDays;
  int get daysSince => DateTime.now().difference(this).inDays;
  int get monthsElapsed {
    final now = DateTime.now();
    return (now.year - year) * 12 + (now.month - month);
  }
}

// ── BuildContext ───────────────────────────────────────────────────────────────

extension ContextExt on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  double get bottomInset => MediaQuery.of(this).viewInsets.bottom;

  Color get cardColor =>
      isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get bgColor =>
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get primaryText =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get secondaryText => AppColors.textSecondary;

  void showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ── String ────────────────────────────────────────────────────────────────────

extension StringExt on String {
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  bool get isValidAmount =>
      isNotEmpty && double.tryParse(replaceAll(',', '')) != null;
  double get toAmount =>
      double.tryParse(replaceAll(',', '')) ?? 0.0;
}
