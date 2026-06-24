import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/extensions.dart';

class AmountDisplay extends StatelessWidget {
  final double amount;
  final double fontSize;
  final Color? color;
  final bool compact;
  final bool showSign;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.fontSize = 28,
    this.color,
    this.compact = false,
    this.showSign = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = compact
        ? amount.takaCompact
        : showSign
            ? amount.takaSign
            : amount.taka;

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        height: 1.1,
      ),
    );
  }
}

class AmountChangeChip extends StatelessWidget {
  final double amount;
  const AmountChangeChip({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final bg = isPositive
        ? AppColors.success.withValues(alpha: 0.12)
        : AppColors.error.withValues(alpha: 0.12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        amount.takaSign,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
