import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/financial_calculator.dart';
import '../../../data/models/investment_model.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/investment_provider.dart';

class InvestmentsScreen extends ConsumerWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investmentsAsync = ref.watch(investmentStreamProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Investments'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          investmentsAsync.when(
            data: (investments) {
              if (investments.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.investments,
                    title: 'No investments yet',
                    subtitle: 'Start tracking your portfolio',
                    actionLabel: 'Add Investment',
                    onAction: () => context.push(AppRoutes.addInvestment),
                  ),
                );
              }
              final totalInvested = investments.fold<double>(
                  0, (s, i) => s + i.investedAmount);
              final totalCurrent = investments.fold<double>(
                  0, (s, i) => s + i.currentValue);
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _PortfolioSummary(
                      totalInvested: totalInvested,
                      totalCurrent: totalCurrent,
                    ),
                    const SizedBox(height: AppSizes.md),
                    ...investments.asMap().entries.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _InvestmentCard(investment: e.value)
                                .animate()
                                .fadeIn(
                                    delay: Duration(milliseconds: e.key * 60),
                                    duration: 300.ms),
                          ),
                        ),
                    const SizedBox(height: 100),
                  ]),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator())),
            error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.warning,
        onPressed: () => context.push(AppRoutes.addInvestment),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PortfolioSummary extends StatelessWidget {
  final double totalInvested;
  final double totalCurrent;
  const _PortfolioSummary(
      {required this.totalInvested, required this.totalCurrent});

  @override
  Widget build(BuildContext context) {
    final pnl = totalCurrent - totalInvested;
    final roi = FinancialCalculator.investmentROI(
        investedAmount: totalInvested, currentValue: totalCurrent);

    return TTGradientCard(
      gradient: LinearGradient(
        colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Portfolio Value',
              style: TextStyle(
                  fontSize: AppSizes.fontSm,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          AmountDisplay(amount: totalCurrent, fontSize: 34, color: Colors.white),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              _PnLChip(amount: pnl),
              const SizedBox(width: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(2)}% ROI',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Invested: ${totalInvested.taka}',
              style: const TextStyle(
                  color: Colors.white54, fontSize: AppSizes.fontSm)),
        ],
      ),
    );
  }
}

class _PnLChip extends StatelessWidget {
  final double amount;
  const _PnLChip({required this.amount});

  @override
  Widget build(BuildContext context) {
    final isPos = amount >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPos
            ? AppColors.success.withValues(alpha: 0.2)
            : AppColors.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        amount.takaSign,
        style: TextStyle(
          color: isPos ? AppColors.success : AppColors.error,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InvestmentCard extends ConsumerWidget {
  final InvestmentModel investment;
  const _InvestmentCard({required this.investment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pnl = investment.currentValue - investment.investedAmount;
    final roi = FinancialCalculator.investmentROI(
        investedAmount: investment.investedAmount,
        currentValue: investment.currentValue);

    return TTCard(
      onTap: () => context.push('/investments/edit/${investment.id}'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(AppIcons.investments,
                color: AppColors.warning, size: 22),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(investment.name,
                    style: const TextStyle(
                        fontSize: AppSizes.fontMd,
                        fontWeight: FontWeight.w600)),
                Text(investment.type,
                    style: const TextStyle(
                        fontSize: AppSizes.fontSm,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(investment.currentValue.taka,
                  style: const TextStyle(
                      fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700)),
              Text('${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(1)}%',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                      color: pnl.profitLossColor)),
            ],
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(AppIcons.delete,
                color: AppColors.textSecondary, size: 18),
            onPressed: () async {
              if (await showDeleteDialog(context)) {
                await ref
                    .read(investmentNotifierProvider.notifier)
                    .delete(investment.id);
                if (context.mounted) {
                  context.showSnack('Investment deleted');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
