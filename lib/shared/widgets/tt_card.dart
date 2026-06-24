import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/extensions.dart';
import '../../core/tokens/design_tokens.dart';

/// Standard app card — static-glass aesthetic (gradient + specular highlight).
/// No BackdropFilter so it is safe to use inside lists/scrollviews.
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
    final isDark = context.isDark;
    final bg = color ?? context.cardColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            splashColor: AppColors.accent.withValues(alpha: 0.05),
            highlightColor: AppColors.accent.withValues(alpha: 0.03),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Blue liquid-glass hero card — net worth / balance display.
class TTHeroCard extends StatelessWidget {
  final Widget child;
  final double radius;

  const TTHeroCard({
    super.key,
    required this.child,
    this.radius = Rad.hero,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final br = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: br,
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0A1628), Color(0xFF1A3A7A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Clr.heroBlueDeep, Clr.heroBlueMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: Clr.heroBlue.withValues(alpha: isDark ? 0.25 : 0.35),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: br,
        child: Padding(
          padding: const EdgeInsets.all(Spc.card + 2),
          child: child,
        ),
      ),
    );
  }
}

/// Gradient card — kept for backward compatibility.
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
