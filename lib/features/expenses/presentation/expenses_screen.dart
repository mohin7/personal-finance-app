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
import '../../../data/models/expense_model.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/expense_provider.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(expenseFilterProvider);
    final expensesAsync = ref.watch(filteredExpensesProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Expenses'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
            trailing: IconButton(
              icon: const Icon(AppIcons.filter),
              onPressed: () => _showFilter(context, ref, filter),
            ),
          ),
          SliverToBoxAdapter(
            child: _FilterChips(current: filter, ref: ref),
          ),
          expensesAsync.when(
            data: (expenses) => expenses.isEmpty
                ? SliverFillRemaining(
                    child: EmptyState(
                      icon: AppIcons.expenses,
                      title: 'No expenses yet',
                      subtitle: 'Tap + to add your first expense',
                      actionLabel: 'Add Expense',
                      onAction: () => context.push(AppRoutes.addExpense),
                    ),
                  )
                : _ExpenseList(expenses: expenses),
            loading: () => const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addExpense),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilter(
      BuildContext context, WidgetRef ref, ExpenseFilter current) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Filter Expenses'),
        actions: ExpenseFilter.values.map((f) {
          return CupertinoActionSheetAction(
            isDefaultAction: f == current,
            onPressed: () {
              ref.read(expenseFilterProvider.notifier).state = f;
              Navigator.pop(context);
            },
            child: Text(f.label),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final ExpenseFilter current;
  final WidgetRef ref;
  const _FilterChips({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
        children: ExpenseFilter.values.map((f) {
          final selected = f == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
            child: FilterChip(
              label: Text(f.label),
              selected: selected,
              onSelected: (_) =>
                  ref.read(expenseFilterProvider.notifier).state = f,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? Colors.white : null,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ExpenseList extends ConsumerWidget {
  final List<ExpenseModel> expenses;
  const _ExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group by date
    final grouped = <String, List<ExpenseModel>>{};
    for (final e in expenses) {
      final key = e.date.relativeDisplay;
      grouped.putIfAbsent(key, () => []).add(e);
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final keys = grouped.keys.toList();
            final key = keys[i];
            final items = grouped[key]!;
            final dayTotal = items.fold<double>(0, (s, e) => s + e.amount);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        key,
                        style: const TextStyle(
                          fontSize: AppSizes.fontSm,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        dayTotal.taka,
                        style: const TextStyle(
                          fontSize: AppSizes.fontSm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                ...items.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.xs),
                    child: _ExpenseItem(expense: e),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms);
          },
          childCount: grouped.length,
        ),
      ),
    );
  }
}

class _ExpenseItem extends ConsumerWidget {
  final ExpenseModel expense;
  const _ExpenseItem({required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TTCard(
      onTap: () =>
          context.push('/expenses/edit/${expense.id}'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              AppIcons.categoryIcon(expense.category),
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category,
                  style: const TextStyle(
                    fontSize: AppSizes.fontMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (expense.note != null && expense.note!.isNotEmpty)
                  Text(
                    expense.note!,
                    style: const TextStyle(
                      fontSize: AppSizes.fontSm,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                expense.amount.taka,
                style: const TextStyle(
                  fontSize: AppSizes.fontMd,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
              Text(
                expense.paymentMethod,
                style: const TextStyle(
                  fontSize: AppSizes.fontXs,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.xs),
          IconButton(
            icon: const Icon(AppIcons.delete,
                color: AppColors.textSecondary, size: 18),
            onPressed: () async {
              final ok =
                  await showDeleteDialog(context);
              if (ok) {
                await ref
                    .read(expenseNotifierProvider.notifier)
                    .delete(expense.id);
                if (context.mounted) {
                  context.showSnack('Expense deleted');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

extension on ExpenseFilter {
  String get label {
    switch (this) {
      case ExpenseFilter.all:
        return 'All Time';
      case ExpenseFilter.today:
        return 'Today';
      case ExpenseFilter.thisMonth:
        return 'This Month';
    }
  }
}
