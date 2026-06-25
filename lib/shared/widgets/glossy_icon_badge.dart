import 'package:flutter/material.dart';

/// iOS-style glossy icon badge — gradient fill + specular top shine + colored shadow.
class GlossyIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  const GlossyIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 46,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.26; // matches iOS app icon rounding ratio
    final light = Color.lerp(color, Colors.white, 0.22)!;
    final dark  = Color.lerp(color, Colors.black, 0.18)!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [light, color, dark],
          stops: const [0.0, 0.55, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Glossy shine — white gradient covering the top ~45% of the badge
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.30),
                    Colors.white.withValues(alpha: 0.00),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(radius),
                ),
              ),
            ),
          ),
          Center(
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
        ],
      ),
    );
  }
}
