import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/tokens/design_tokens.dart';

/// iOS 26-style Liquid Glass surface — blur + specular + gradient border.
///
/// Use for floating / overlapping elements only: nav bars, modals, FABs.
/// For list cards use [TTCard], which has a static-glass aesthetic without
/// the BackdropFilter performance cost.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.radius = Rad.lg,
    this.padding,
    this.blur = Glass.sigmaModal,
    this.fillColor,
    this.onTap,
    this.shadow = true,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? fillColor;
  final VoidCallback? onTap;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fill = fillColor ??
        (isDark ? Glass.fillDark : Glass.fillLight);

    final List<BoxShadow> shadows = shadow
        ? isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Clr.heroBlue.withValues(alpha: 0.07),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
        : [];

    Widget content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: _GlassBody(
            isDark: isDark,
            fill: fill,
            radius: radius,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _GlassBody extends StatelessWidget {
  const _GlassBody({
    required this.isDark,
    required this.fill,
    required this.radius,
    required this.child,
  });

  final bool isDark;
  final Color fill;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);

    return Stack(
      children: [
        // Base frosted fill
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: br,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [Glass.fillDarkDeep, Glass.fillDark]
                    : [Glass.fillLightDeep, Glass.fillLight],
              ),
            ),
          ),
        ),

        // Specular highlight — bright strip at the top edge
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: radius * 1.8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark ? Glass.specDark : Glass.specLight,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Inset border drawn over content
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: br,
                border: Border.all(
                  color: isDark ? Glass.borderDark : Glass.borderLight,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),

        // Content
        child,
      ],
    );
  }
}
