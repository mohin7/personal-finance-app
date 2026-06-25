import 'package:flutter/material.dart';

/// Drop-in icon widget backed by CupertinoIcons / any IconData.
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const AppIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? IconTheme.of(context).size ?? 24,
      color: color ?? IconTheme.of(context).color,
    );
  }
}
