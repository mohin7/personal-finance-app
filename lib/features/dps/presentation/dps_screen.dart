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
import '../../../data/models/dps_model.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/dps_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class DpsScreen extends ConsumerWidget {
  const DpsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dpsAsync = ref.watch(dpsStreamProvider);
    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('DPS'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          dpsAsync.when(
            data: (dpsList) {
              if (dpsList.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.dps,
                    title: 'No DPS accounts',
                    subtitle: 'Add your Deposit Pension Scheme',
                    actionLabel: 'Add DPS',
                    onAction: () => context.push(AppRoutes.addDps),
                  ),
                );
              }
              final totalCurrent = dpsList
                  .where((d) => d.isActive)
                  .fold<double>(
                      0,
                      (s, d) =>
                          s +
                          FinancialCalculator.dpsCurrentValue(
                              monthlyDeposit: d.monthlyDeposit,
                              annualRate: d.interestRate,
                              startDate: d.startDate));
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TTGradientCard(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF006A4E), Color(0xFF00A878)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total DPS Value',
                              style: TextStyle(
                                  fontSize: AppSizes.fontSm,
                                  color: Colors.white70)),
                          const SizedBox(height: 4),
                          AmountDisplay(
                              amount: totalCurrent,
                              fontSize: 34,
                              color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    ...dpsList.asMap().entries.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _DpsCard(dps: e.value)
                                .animate()
                                .fadeIn(
                                    delay: Duration(
                                        milliseconds: e.key * 60),
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
        onPressed: () => context.push(AppRoutes.addDps),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

class _DpsCard extends ConsumerWidget {
  final DpsModel dps;
  const _DpsCard({required this.dps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentValue = FinancialCalculator.dpsCurrentValue(
        monthlyDeposit: dps.monthlyDeposit,
        annualRate: dps.interestRate,
        startDate: dps.startDate);
    final maturityValue = FinancialCalculator.dpsMaturityValue(
        monthlyDeposit: dps.monthlyDeposit,
        annualRate: dps.interestRate,
        totalMonths: dps.maturityDate.monthsElapsed == 0
            ? 12
            : (dps.maturityDate.year - dps.startDate.year) * 12 +
                (dps.maturityDate.month - dps.startDate.month));
    final monthsLeft = dps.maturityDate.daysUntil ~/ 30;
    final progress = dps.startDate.monthsElapsed /
        ((dps.maturityDate.year - dps.startDate.year) * 12 +
            (dps.maturityDate.month - dps.startDate.month))
            .clamp(1, 999);

    return TTCard(
      onTap: () => context.push('/dps/edit/${dps.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: AppIcon(AppIcons.dps,
                    color: AppColors.primary, size: 18)),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dps.dpsName,
                        style: const TextStyle(
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.w600)),
                    Text(dps.bankName,
                        style: const TextStyle(
                            fontSize: AppSizes.fontSm,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountDisplay(amount: currentValue, fontSize: 16),
                  Text('of ${maturityValue.taka}',
                      style: const TextStyle(
                          fontSize: AppSizes.fontXs,
                          color: AppColors.textSecondary)),
                ],
              ),
              IconButton(
                icon: const AppIcon(AppIcons.delete,
                    color: AppColors.textSecondary, size: 18),
                onPressed: () async {
                  if (await showDeleteDialog(context)) {
                    await ref
                        .read(dpsNotifierProvider.notifier)
                        .delete(dps.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.primaryContainer,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('৳${dps.monthlyDeposit.toStringAsFixed(0)}/month',
                  style: const TextStyle(
                      fontSize: AppSizes.fontXs,
                      color: AppColors.textSecondary)),
              Text(
                  monthsLeft > 0
                      ? '$monthsLeft months left'
                      : 'Matured',
                  style: TextStyle(
                      fontSize: AppSizes.fontXs,
                      color: monthsLeft > 0
                          ? AppColors.textSecondary
                          : AppColors.success,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
