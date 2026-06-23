import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/extensions.dart';

/// Base card used throughout TakaTrack.
class TTCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;

  const TTCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.radius = AppSizes.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? context.cardColor;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
          child: child,
        ),
      ),
    );
  }
}

/// Gradient card (used for Net Worth hero).
class TTGradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  final double radius;

  const TTGradientCard({
    super.key,
    required this.child,
    this.gradient = AppColors.primaryGradient,
    this.radius = AppSizes.heroCardRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.all(AppSizes.cardPadding + 4),
      child: child,
    );
  }
}
