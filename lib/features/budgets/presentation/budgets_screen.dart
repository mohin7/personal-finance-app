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
import '../../../data/models/budget_model.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/budget_provider.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(currentMonthBudgetsProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Budget Planner'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          budgetsAsync.when(
            data: (budgets) {
              if (budgets.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyState(
                    icon: AppIcons.budget,
                    title: 'No budgets set',
                    subtitle: 'Plan your monthly spending',
                    actionLabel: 'Create Budget',
                    onAction: () => context.push(AppRoutes.addBudget),
                  ),
                );
              }
              final totalAllocated = budgets.fold<double>(
                  0, (s, b) => s + b.allocatedAmount);
              final totalSpent =
                  budgets.fold<double>(0, (s, b) => s + b.spentAmount);
              final overallPercent =
                  totalAllocated > 0 ? totalSpent / totalAllocated : 0.0;

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _OverallSummaryCard(
                      allocated: totalAllocated,
                      spent: totalSpent,
                      percent: overallPercent,
                    ),
                    const SizedBox(height: AppSizes.md),
                    ...budgets.asMap().entries.map(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.sm),
                            child: _BudgetCard(budget: e.value)
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
        backgroundColor: AppColors.warning,
        onPressed: () => context.push(AppRoutes.addBudget),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _OverallSummaryCard extends StatelessWidget {
  final double allocated;
  final double spent;
  final double percent;
  const _OverallSummaryCard(
      {required this.allocated,
      required this.spent,
      required this.percent});

  @override
  Widget build(BuildContext context) {
    final isOver = spent > allocated;
    return TTCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('This Month',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              Text('${(percent * 100).toStringAsFixed(0)}% used',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      fontWeight: FontWeight.w700,
                      color: isOver ? AppColors.error : AppColors.success)),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              backgroundColor: AppColors.primaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isOver ? AppColors.error : AppColors.warning),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spent: ${spent.taka}',
                  style: TextStyle(
                      fontSize: AppSizes.fontSm,
                      color: isOver ? AppColors.error : context.primaryText,
                      fontWeight: FontWeight.w600)),
              Text('Budget: ${allocated.taka}',
                  style: const TextStyle(
                      fontSize: AppSizes.fontSm,
                      color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends ConsumerWidget {
  final BudgetModel budget;
  const _BudgetCard({required this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percent = budget.usedPercent.clamp(0.0, 1.0);
    final isOver = budget.isOverBudget;

    return TTCard(
      onTap: () => context.push('/budgets/edit/${budget.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isOver
                      ? AppColors.error.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(AppIcons.categoryIcon(budget.category),
                    color: isOver ? AppColors.error : AppColors.warning,
                    size: 20),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(budget.category,
                        style: const TextStyle(
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.w600)),
                    Text(
                        '${budget.spentAmount.taka} of ${budget.allocatedAmount.taka}',
                        style: const TextStyle(
                            fontSize: AppSizes.fontSm,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${(percent * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                          fontSize: AppSizes.fontSm,
                          fontWeight: FontWeight.w700,
                          color: isOver
                              ? AppColors.error
                              : AppColors.success)),
                  Text(
                      isOver
                          ? '${budget.remainingAmount.abs().taka} over'
                          : '${budget.remainingAmount.taka} left',
                      style: TextStyle(
                          fontSize: AppSizes.fontXs,
                          color: isOver
                              ? AppColors.error
                              : AppColors.textSecondary)),
                ],
              ),
              IconButton(
                icon: const Icon(AppIcons.delete,
                    color: AppColors.textSecondary, size: 18),
                onPressed: () async {
                  if (await showDeleteDialog(context)) {
                    await ref
                        .read(budgetNotifierProvider.notifier)
                        .delete(budget.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.primaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isOver ? AppColors.error : AppColors.warning),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
