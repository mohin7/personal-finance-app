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
import '../../../data/models/fdr_model.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/fdr_provider.dart';

class FdrScreen extends ConsumerWidget {
  const FdrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fdrAsync = ref.watch(fdrStreamProvider);
    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('FDR'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          fdrAsync.when(
            data: (fdrList) {
              if (fdrList.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.fdr,
                    title: 'No FDR accounts',
                    subtitle: 'Add your Fixed Deposit Receipts',
                    actionLabel: 'Add FDR',
                    onAction: () => context.push(AppRoutes.addFdr),
                  ),
                );
              }
              final totalCurrent = fdrList
                  .where((f) => f.isActive)
                  .fold<double>(
                      0,
                      (s, f) =>
                          s +
                          FinancialCalculator.fdrCurrentValue(
                              principal: f.principalAmount,
                              annualRate: f.interestRate,
                              startDate: f.startDate));
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TTGradientCard(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004D38), Color(0xFF006A4E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total FDR Value',
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
                    ...fdrList.asMap().entries.map((e) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSizes.sm),
                          child: _FdrCard(fdr: e.value)
                              .animate()
                              .fadeIn(
                                  delay: Duration(
                                      milliseconds: e.key * 60),
                                  duration: 300.ms),
                        )),
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
        onPressed: () => context.push(AppRoutes.addFdr),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FdrCard extends ConsumerWidget {
  final FdrModel fdr;
  const _FdrCard({required this.fdr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentValue = FinancialCalculator.fdrCurrentValue(
        principal: fdr.principalAmount,
        annualRate: fdr.interestRate,
        startDate: fdr.startDate);
    final daysLeft = fdr.maturityDate.daysUntil;
    final profit = currentValue - fdr.principalAmount;

    return TTCard(
      onTap: () => context.push('/fdr/edit/${fdr.id}'),
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
                child: const Icon(AppIcons.fdr,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fdr.fdrName,
                        style: const TextStyle(
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.w600)),
                    Text(fdr.bankName,
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
                  Text('+${profit.taka} profit',
                      style: const TextStyle(
                          fontSize: AppSizes.fontXs,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              IconButton(
                icon: const Icon(AppIcons.delete,
                    color: AppColors.textSecondary, size: 18),
                onPressed: () async {
                  if (await showDeleteDialog(context)) {
                    await ref
                        .read(fdrNotifierProvider.notifier)
                        .delete(fdr.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Principal: ${fdr.principalAmount.taka} @ ${fdr.interestRate}%',
                  style: const TextStyle(
                      fontSize: AppSizes.fontXs,
                      color: AppColors.textSecondary)),
              Text(
                  daysLeft > 0
                      ? '$daysLeft days left'
                      : 'Matured',
                  style: TextStyle(
                      fontSize: AppSizes.fontXs,
                      color: daysLeft > 0
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
