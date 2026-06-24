import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Drop-in replacement for [Icon] when using HugeIcons.
/// Accepts the same positional + named parameters as [Icon] so call-sites
/// change from  Icon(AppIcons.xxx, size: 20, color: c)
///           to AppIcon(AppIcons.xxx, size: 20, color: c)
class AppIcon extends StatelessWidget {
  final List<List<dynamic>> icon;
  final double? size;
  final Color? color;

  const AppIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? IconTheme.of(context).color ?? Colors.black;
    return HugeIcon(
      icon: icon,
      size: size ?? IconTheme.of(context).size ?? 24,
      color: resolved,
      strokeWidth: 1.6,
    );
  }
}
