import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
    (CupertinoIcons.house_fill,              CupertinoIcons.house,              AppRoutes.dashboard),
    (CupertinoIcons.arrow_down_circle_fill,  CupertinoIcons.arrow_down_circle,  AppRoutes.expenses),
    (CupertinoIcons.arrow_up_circle_fill,    CupertinoIcons.arrow_up_circle,    AppRoutes.income),
    (CupertinoIcons.chart_pie_fill,          CupertinoIcons.chart_pie,          AppRoutes.investments),
    (CupertinoIcons.ellipsis_circle_fill,    CupertinoIcons.ellipsis_circle,    AppRoutes.more),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    // Glass fill — dark: translucent dark card, light: frosted white
    final glassFill = isDark
        ? const Color(0xCC1E1E1E) // darkCard at 80% opacity
        : const Color(0xCCFFFFFF); // white at 80% opacity

    // Specular top-edge highlight
    final specular = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.95);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad + 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Rad.full),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
              child: Container(
                height: 62,
                decoration: BoxDecoration(
                  color: glassFill,
                  borderRadius: BorderRadius.circular(Rad.full),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.10)
                        : Colors.black.withValues(alpha: 0.06),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.10),
                      blurRadius: isDark ? 32 : 20,
                      offset: const Offset(0, 10),
                    ),
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: _items.map((item) {
                    final (activeIcon, inactiveIcon, route) = item;
                    return _NavTile(
                      activeIcon: activeIcon,
                      inactiveIcon: inactiveIcon,
                      route: route,
                      active: location == route,
                      isDark: isDark,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Specular highlight — the glass "edge" glint at the top
          Positioned(
            top: 1,
            left: 20,
            right: 20,
            child: Container(
              height: 0.5,
              decoration: BoxDecoration(
                color: specular,
                borderRadius: BorderRadius.circular(Rad.full),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String route;
  final bool active;
  final bool isDark;

  const _NavTile({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.route,
    required this.active,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor  = isDark ? Clr.navPillDark  : Clr.navPillLight;
    final activePillBg = activeColor.withValues(alpha: isDark ? 0.16 : 0.10);
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.35)
        : Clr.textDark.withValues(alpha: 0.38);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(route);
        },
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: active ? 18 : 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: active ? activePillBg : Colors.transparent,
              borderRadius: BorderRadius.circular(Rad.full),
            ),
            child: Icon(
              active ? activeIcon : inactiveIcon,
              size: 22,
              color: active ? activeColor : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
