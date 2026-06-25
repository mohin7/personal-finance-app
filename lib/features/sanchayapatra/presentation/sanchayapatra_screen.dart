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
import '../../../data/models/sanchayapatra_model.dart';
import '../../../shared/widgets/amount_display.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/sanchayapatra_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class SanchayapatraScreen extends ConsumerWidget {
  const SanchayapatraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spAsync = ref.watch(sanchayapatraStreamProvider);
    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Sanchayapatra'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          spAsync.when(
            data: (spList) {
              if (spList.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.sanchayapatra,
                    title: 'No Sanchayapatra',
                    subtitle: 'Add your national savings certificates',
                    actionLabel: 'Add Sanchayapatra',
                    onAction: () => context.push(AppRoutes.addSanchayapatra),
                  ),
                );
              }
              final totalCurrent = spList
                  .where((sp) => sp.isActive)
                  .fold<double>(
                      0,
                      (s, sp) =>
                          s +
                          FinancialCalculator.sanchayapatraCurrentValue(
                              purchaseAmount: sp.purchaseAmount,
                              annualProfitRate: sp.profitRate,
                              purchaseDate: sp.purchaseDate));
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TTGradientCard(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF42A41), Color(0xFFFF6B7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Sanchayapatra Value',
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
                    ...spList.asMap().entries.map((e) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSizes.sm),
                          child: _SpCard(sp: e.value)
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
        backgroundColor: AppColors.accent,
        onPressed: () => context.push(AppRoutes.addSanchayapatra),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

class _SpCard extends ConsumerWidget {
  final SanchayapatraModel sp;
  const _SpCard({required this.sp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentValue = FinancialCalculator.sanchayapatraCurrentValue(
        purchaseAmount: sp.purchaseAmount,
        annualProfitRate: sp.profitRate,
        purchaseDate: sp.purchaseDate);
    final maturityValue = FinancialCalculator.sanchayapatraMaturityValue(
        purchaseAmount: sp.purchaseAmount,
        annualProfitRate: sp.profitRate,
        purchaseDate: sp.purchaseDate,
        maturityDate: sp.maturityDate);
    final profit = currentValue - sp.purchaseAmount;
    final daysLeft = sp.maturityDate.daysUntil;

    return TTCard(
      onTap: () => context.push('/sanchayapatra/edit/${sp.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: AppIcon(AppIcons.sanchayapatra,
                    color: AppColors.accent, size: 18)),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sp.schemeName,
                        style: const TextStyle(
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.w600)),
                    Text('Rate: ${sp.profitRate}% p.a.',
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
                  Text('+${profit.taka}',
                      style: const TextStyle(
                          fontSize: AppSizes.fontXs,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              IconButton(
                icon: const AppIcon(AppIcons.delete,
                    color: AppColors.textSecondary, size: 18),
                onPressed: () async {
                  if (await showDeleteDialog(context)) {
                    await ref
                        .read(sanchayapatraNotifierProvider.notifier)
                        .delete(sp.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Maturity: ${maturityValue.taka}',
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
