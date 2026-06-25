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
    final br = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: br,
        // Glass edge border — dark: subtle white rim, light: soft shadow rim
        border: isDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5)
            : Border.all(color: Colors.black.withValues(alpha: 0.04), width: 0.5),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
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
        borderRadius: br,
        child: Stack(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: br,
                splashColor: AppColors.accent.withValues(alpha: 0.05),
                highlightColor: AppColors.accent.withValues(alpha: 0.03),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
                  child: child,
                ),
              ),
            ),
            // Specular top-edge glint — the glass "meniscus" highlight
            if (isDark)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
                  ),
                ),
              ),
          ],
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
    final br = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: br,
        gradient: const LinearGradient(
              colors: [Color(0xFF020E09), Color(0xFF004030)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        boxShadow: [
          BoxShadow(
            color: Clr.accent.withValues(alpha: 0.28),
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
