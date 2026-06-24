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
import '../../../data/models/income_model.dart';
import '../../../shared/widgets/delete_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/income_provider.dart';
import '../../../shared/widgets/app_icon.dart';

class IncomeScreen extends ConsumerWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(incomeFilterProvider);
    final incomesAsync = ref.watch(filteredIncomesProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Income'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                children: IncomeFilter.values.map((f) {
                  final sel = f == filter;
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                    child: FilterChip(
                      label: Text(f.label),
                      selected: sel,
                      onSelected: (_) =>
                          ref.read(incomeFilterProvider.notifier).state = f,
                      selectedColor: AppColors.success,
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          incomesAsync.when(
            data: (incomes) => incomes.isEmpty
                ? SliverFillRemaining(
                    child: EmptyState(
                      icon: AppIcons.income,
                      title: 'No income yet',
                      subtitle: 'Tap + to record income',
                      actionLabel: 'Add Income',
                      onAction: () => context.push(AppRoutes.addIncome),
                    ),
                  )
                : _IncomeList(incomes: incomes),
            loading: () => const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (e, _) =>
                SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.success,
        onPressed: () => context.push(AppRoutes.addIncome),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IncomeList extends ConsumerWidget {
  final List<IncomeModel> incomes;
  const _IncomeList({required this.incomes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = <String, List<IncomeModel>>{};
    for (final e in incomes) {
      grouped.putIfAbsent(e.date.relativeDisplay, () => []).add(e);
    }

    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
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
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(key,
                          style: const TextStyle(
                              fontSize: AppSizes.fontSm,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary)),
                      Text(dayTotal.taka,
                          style: const TextStyle(
                              fontSize: AppSizes.fontSm,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success)),
                    ],
                  ),
                ),
                ...items.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.xs),
                      child: _IncomeItem(income: e),
                    )),
              ],
            ).animate().fadeIn(duration: 300.ms);
          },
          childCount: grouped.length,
        ),
      ),
    );
  }
}

class _IncomeItem extends ConsumerWidget {
  final IncomeModel income;
  const _IncomeItem({required this.income});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TTCard(
      onTap: () => context.push('/income/edit/${income.id}'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: AppIcon(AppIcons.income, color: AppColors.success, size: 18)),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(income.source,
                    style: const TextStyle(
                        fontSize: AppSizes.fontMd, fontWeight: FontWeight.w600)),
                if (income.notes != null && income.notes!.isNotEmpty)
                  Text(income.notes!,
                      style: const TextStyle(
                          fontSize: AppSizes.fontSm,
                          color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(income.amount.taka,
              style: const TextStyle(
                  fontSize: AppSizes.fontMd,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success)),
          const SizedBox(width: 4),
          IconButton(
            icon: const AppIcon(AppIcons.delete,
                color: AppColors.textSecondary, size: 18),
            onPressed: () async {
              if (await showDeleteDialog(context)) {
                await ref
                    .read(incomeNotifierProvider.notifier)
                    .delete(income.id);
                if (context.mounted) context.showSnack('Income deleted');
              }
            },
          ),
        ],
      ),
    );
  }
}

extension on IncomeFilter {
  String get label {
    switch (this) {
      case IncomeFilter.all:
        return 'All Time';
      case IncomeFilter.today:
        return 'Today';
      case IncomeFilter.thisMonth:
        return 'This Month';
    }
  }
}
