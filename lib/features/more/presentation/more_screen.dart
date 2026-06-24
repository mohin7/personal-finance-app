import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/widgets/app_icon.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/router/app_router.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('More'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionLabel('Accounts'),
                _MoreItem(
                  icon: AppIcons.cash,
                  label: 'Cash Management',
                  subtitle: 'Track cash & wallets',
                  color: AppColors.success,
                  route: AppRoutes.cash,
                ),
                _MoreItem(
                  icon: AppIcons.bank,
                  label: 'Bank Accounts',
                  subtitle: 'Manage bank balances',
                  color: AppColors.info,
                  route: AppRoutes.banks,
                ),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('Savings'),
                _MoreItem(
                  icon: AppIcons.dps,
                  label: 'DPS',
                  subtitle: 'Deposit Pension Scheme',
                  color: AppColors.primary,
                  route: AppRoutes.dps,
                ),
                _MoreItem(
                  icon: AppIcons.fdr,
                  label: 'FDR',
                  subtitle: 'Fixed Deposit Receipt',
                  color: AppColors.primaryDark,
                  route: AppRoutes.fdr,
                ),
                _MoreItem(
                  icon: AppIcons.sanchayapatra,
                  label: 'Sanchayapatra',
                  subtitle: 'National savings certificates',
                  color: AppColors.accentLight,
                  route: AppRoutes.sanchayapatra,
                ),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('Planning'),
                _MoreItem(
                  icon: AppIcons.budget,
                  label: 'Budget Planner',
                  subtitle: 'Set monthly budgets',
                  color: AppColors.warning,
                  route: AppRoutes.budgets,
                ),
                _MoreItem(
                  icon: AppIcons.reports,
                  label: 'Reports & Analytics',
                  subtitle: 'Detailed financial reports',
                  color: AppColors.info,
                  route: AppRoutes.reports,
                ),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('Lend & Borrow'),
                _MoreItem(
                  icon: HugeIcons.strokeRoundedAgreement01,
                  label: 'Lend & Borrow',
                  subtitle: 'Track money given or taken',
                  color: AppColors.warning,
                  route: AppRoutes.loans,
                ),
                const SizedBox(height: AppSizes.md),
                _SectionLabel('General'),
                _MoreItem(
                  icon: AppIcons.settings,
                  label: 'Settings',
                  subtitle: 'App preferences & security',
                  color: AppColors.textSecondary,
                  route: AppRoutes.settings,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: AppSizes.fontXs,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String subtitle;
  final Color color;
  final String route;

  const _MoreItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(child: AppIcon(icon, color: color, size: 17)),
        ),
        title: Text(label,
            style: const TextStyle(
                fontSize: AppSizes.fontMd, fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Text(subtitle,
              style: const TextStyle(
                  fontSize: AppSizes.fontSm, color: AppColors.textSecondary)),
        ),
        trailing: const Icon(CupertinoIcons.chevron_right,
            color: AppColors.textSecondary, size: 16),
        onTap: () => context.push(route),
      ),
    );
  }
}
