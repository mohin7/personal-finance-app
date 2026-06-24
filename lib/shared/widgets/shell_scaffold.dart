import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../core/tokens/design_tokens.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: _FloatingNav(location: location, isDark: isDark),
    );
  }
}

class _FloatingNav extends StatelessWidget {
  final String location;
  final bool isDark;
  const _FloatingNav({required this.location, required this.isDark});

  static const _items = [
    (AppIcons.dashboard, AppStrings.navDashboard, AppRoutes.dashboard),
    (AppIcons.expenses, AppStrings.navExpenses, AppRoutes.expenses),
    (AppIcons.income, AppStrings.navIncome, AppRoutes.income),
    (AppIcons.investments, AppStrings.navInvestments, AppRoutes.investments),
    (AppIcons.more, AppStrings.navMore, AppRoutes.more),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final navBg = isDark ? Clr.darkCard : Colors.white;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad + 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: navBg,
          borderRadius: BorderRadius.circular(Rad.full),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Clr.heroBlue.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: SizedBox(
          height: 62,
          child: Row(
            children: _items.map((item) {
              final (icon, label, route) = item;
              final active = location == route;
              return _NavTile(
                icon: icon,
                label: label,
                route: route,
                active: active,
                isDark: isDark,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String route;
  final bool active;
  final bool isDark;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.route,
    required this.active,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? Clr.navPillDark : Clr.navPillLight;
    final activePillBg = activeColor.withValues(alpha: isDark ? 0.18 : 0.10);
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.38)
        : Clr.textMid;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(route);
        },
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: active ? 18 : 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: active ? activePillBg : Colors.transparent,
              borderRadius: BorderRadius.circular(Rad.full),
            ),
            child: HugeIcon(
              icon: icon,
              size: 22,
              color: active ? activeColor : inactiveColor,
              strokeWidth: active ? 1.6 : 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
