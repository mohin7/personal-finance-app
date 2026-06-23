import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/financial_calculator.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardProvider);
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, isDark),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSizes.md),
                summary.when(
                  data: (s) => _DashboardContent(summary: s),
                  loading: () => const _DashboardSkeleton(),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, bool isDark) {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good morning'
        : now.hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      expandedHeight: 90,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        fontSize: AppSizes.fontSm,
                        color: context.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: AppSizes.fontXxl + 2,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  radius: 20,
                  child: const Icon(
                    AppIcons.notification,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardSummary summary;
  const _DashboardContent({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Net Worth Hero ───────────────────────────────────────────
        _NetWorthCard(summary: summary)
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),

        const SizedBox(height: AppSizes.md),

        // ── Asset Summary Row ────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                label: 'Cash',
                amount: summary.totalCash,
                icon: AppIcons.cash,
                color: AppColors.success,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _MiniStatCard(
                label: 'Bank',
                amount: summary.totalBank,
                icon: AppIcons.bank,
                color: AppColors.info,
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _MiniStatCard(
                label: 'Invest',
                amount: summary.totalInvestments,
                icon: AppIcons.investments,
                color: AppColors.warning,
                onTap: () {},
              ),
            ),
          ],
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

        const SizedBox(height: AppSizes.md),

        // ── Monthly Income / Expense ──────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _IncomeExpenseCard(
                label: 'Income',
                amount: summary.monthlyIncome,
                icon: AppIcons.income,
                positive: true,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _IncomeExpenseCard(
                label: 'Expenses',
                amount: summary.monthlyExpense,
                icon: AppIcons.expenses,
                positive: false,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

        const SizedBox(height: AppSizes.md),

        // ── Savings Card ─────────────────────────────────────────────
        _SavingsCard(summary: summary)
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms),

        const SizedBox(height: AppSizes.sectionSpacing),

        // ── Savings Instruments ──────────────────────────────────────
        SectionHeader(
          title: 'Savings',
          action: 'See all',
          onAction: () {},
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: _InstrumentCard(
                label: 'DPS',
                amount: summary.totalDps,
                icon: AppIcons.dps,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _InstrumentCard(
                label: 'FDR',
                amount: summary.totalFdr,
                icon: AppIcons.fdr,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _InstrumentCard(
                label: 'Sanchay.',
                amount: summary.totalSanchayapatra,
                icon: AppIcons.sanchayapatra,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

        const SizedBox(height: AppSizes.sectionSpacing),

        // ── Financial Health ─────────────────────────────────────────
        SectionHeader(title: 'Financial Health'),
        const SizedBox(height: AppSizes.sm),
        _HealthScoreCard(summary: summary)
            .animate()
            .fadeIn(delay: 300.ms, duration: 400.ms),

        const SizedBox(height: AppSizes.sectionSpacing),

        // ── Today ─────────────────────────────────────────────────────
        SectionHeader(title: 'Today'),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                label: "Today's Income",
                amount: summary.todayIncome,
                icon: AppIcons.income,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _MiniStatCard(
                label: "Today's Expense",
                amount: summary.todayExpense,
                icon: AppIcons.expenses,
                color: AppColors.error,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
      ],
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  final DashboardSummary summary;
  const _NetWorthCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return TTGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Net Worth',
            style: TextStyle(
              fontSize: AppSizes.fontMd,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          AmountDisplay(
            amount: summary.netWorth,
            fontSize: 38,
            color: Colors.white,
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              _NetWorthStat(
                label: 'Monthly Savings',
                amount: summary.monthlySavings,
              ),
              const SizedBox(width: AppSizes.lg),
              _NetWorthStat(
                label: 'Savings Rate',
                text: '${summary.savingsRate.toStringAsFixed(1)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetWorthStat extends StatelessWidget {
  final String label;
  final double? amount;
  final String? text;
  const _NetWorthStat({required this.label, this.amount, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppSizes.fontXs,
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          text ?? (amount?.taka ?? ''),
          style: const TextStyle(
            fontSize: AppSizes.fontMd,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _MiniStatCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TTCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppSizes.fontXs,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          AmountDisplay(amount: amount, fontSize: 15, compact: true),
        ],
      ),
    );
  }
}

class _IncomeExpenseCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final bool positive;

  const _IncomeExpenseCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? AppColors.success : AppColors.error;
    return TTCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppSizes.fontXs,
                    color: AppColors.textSecondary,
                  ),
                ),
                AmountDisplay(amount: amount, fontSize: 16, compact: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsCard extends StatelessWidget {
  final DashboardSummary summary;
  const _SavingsCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final rate = summary.savingsRate;
    final savings = summary.monthlySavings;
    final isPositive = savings >= 0;

    return TTCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Savings',
                  style: TextStyle(
                    fontSize: AppSizes.fontSm,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                AmountDisplay(
                  amount: savings,
                  fontSize: 22,
                  color: savings.profitLossColor,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Savings Rate',
                style: const TextStyle(
                  fontSize: AppSizes.fontXs,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${rate.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: AppSizes.fontXxl,
                  fontWeight: FontWeight.w800,
                  color: isPositive ? AppColors.success : AppColors.error,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InstrumentCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;

  const _InstrumentCard({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TTCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppSizes.fontXs,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          AmountDisplay(amount: amount, fontSize: 14, compact: true),
        ],
      ),
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  final DashboardSummary summary;
  const _HealthScoreCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final score = summary.healthScore;
    final label = FinancialCalculator.healthLabel(score);
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.primary
            : score >= 40
                ? AppColors.warning
                : AppColors.error;

    return TTCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 6,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(
                  score.toInt().toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.fontLg,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Based on savings rate, investments & net worth',
                  style: TextStyle(
                    fontSize: AppSizes.fontXs,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: AppSizes.sm),
          height: 80,
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
        ),
      ),
    );
  }
}
