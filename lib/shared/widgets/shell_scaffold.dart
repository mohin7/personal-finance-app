import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.separatorDark : AppColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                _NavItem(
                  icon: AppIcons.dashboard,
                  label: AppStrings.navDashboard,
                  route: AppRoutes.dashboard,
                  active: location == AppRoutes.dashboard,
                ),
                _NavItem(
                  icon: AppIcons.expenses,
                  label: AppStrings.navExpenses,
                  route: AppRoutes.expenses,
                  active: location == AppRoutes.expenses,
                ),
                _NavItem(
                  icon: AppIcons.income,
                  label: AppStrings.navIncome,
                  route: AppRoutes.income,
                  active: location == AppRoutes.income,
                ),
                _NavItem(
                  icon: AppIcons.investments,
                  label: AppStrings.navInvestments,
                  route: AppRoutes.investments,
                  active: location == AppRoutes.investments,
                ),
                _NavItem(
                  icon: AppIcons.more,
                  label: AppStrings.navMore,
                  route: AppRoutes.more,
                  active: location == AppRoutes.more,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final effectiveColor = active ? activeColor : AppColors.textSecondary;

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => context.go(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: effectiveColor, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
