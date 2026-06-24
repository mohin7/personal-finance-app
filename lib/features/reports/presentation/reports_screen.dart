import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/tt_card.dart';
import '../../../shared/widgets/app_icon.dart';

final _reportMonthProvider = StateProvider<DateTime>(
    (ref) => DateTime(DateTime.now().year, DateTime.now().month));

final _expenseByMonthProvider =
    FutureProvider.autoDispose.family<double, DateTime>((ref, month) async {
  return ref
      .read(expenseRepositoryProvider)
      .totalByMonth(month.month, month.year);
});

final _incomeByMonthProvider =
    FutureProvider.autoDispose.family<double, DateTime>((ref, month) async {
  return ref
      .read(incomeRepositoryProvider)
      .totalByMonth(month.month, month.year);
});

final _expenseByCategoryProvider =
    FutureProvider.autoDispose.family<Map<String, double>, DateTime>(
        (ref, month) async {
  final expenses = await ref
      .read(expenseRepositoryProvider)
      .getByMonth(month.month, month.year);
  final map = <String, double>{};
  for (final e in expenses) {
    map[e.category] = (map[e.category] ?? 0) + e.amount;
  }
  return map;
});

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(_reportMonthProvider);
    final expenseAsync = ref.watch(_expenseByMonthProvider(selectedMonth));
    final incomeAsync = ref.watch(_incomeByMonthProvider(selectedMonth));
    final byCategoryAsync =
        ref.watch(_expenseByCategoryProvider(selectedMonth));

    return Scaffold(
      backgroundColor: context.bgColor,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Reports'),
            backgroundColor: context.bgColor,
            border: Border.all(color: Colors.transparent),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Month picker
                _MonthPicker(
                  selected: selectedMonth,
                  onChanged: (m) =>
                      ref.read(_reportMonthProvider.notifier).state = m,
                ),
                const SizedBox(height: AppSizes.md),

                // Income vs Expense
                TTCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: 'Income vs Expense'),
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        children: [
                          _StatBox(
                            label: 'Income',
                            valueAsync: incomeAsync,
                            color: AppColors.success,
                            icon: AppIcons.income,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          _StatBox(
                            label: 'Expense',
                            valueAsync: expenseAsync,
                            color: AppColors.error,
                            icon: AppIcons.expenses,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          _NetBox(
                              incomeAsync: incomeAsync,
                              expenseAsync: expenseAsync),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                // Expense by Category (pie chart)
                byCategoryAsync.when(
                  data: (byCategory) {
                    if (byCategory.isEmpty) return const SizedBox();
                    return TTCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(title: 'Spending by Category'),
                          const SizedBox(height: AppSizes.md),
                          SizedBox(
                            height: 200,
                            child: _ExpensePieChart(data: byCategory),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _CategoryLegend(data: byCategory),
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CupertinoActivityIndicator()),
                  error: (_, __) => const SizedBox(),
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

class _MonthPicker extends StatelessWidget {
  final DateTime selected;
  final void Function(DateTime) onChanged;
  const _MonthPicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.left_chevron),
          onPressed: () => onChanged(
              DateTime(selected.year, selected.month - 1)),
        ),
        Text(
          '${_monthName(selected.month)} ${selected.year}',
          style: const TextStyle(
              fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.right_chevron),
          onPressed: selected.year == DateTime.now().year &&
                  selected.month == DateTime.now().month
              ? null
              : () => onChanged(
                  DateTime(selected.year, selected.month + 1)),
        ),
      ],
    );
  }

  String _monthName(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];
}

class _StatBox extends StatelessWidget {
  final String label;
  final AsyncValue<double> valueAsync;
  final Color color;
  final List<List<dynamic>> icon;
  const _StatBox({
    required this.label,
    required this.valueAsync,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            valueAsync.when(
              data: (v) => Text(v.taka,
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              loading: () => const SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, __) => const Text('-'),
            ),
            Text(label,
                style: const TextStyle(
                    fontSize: AppSizes.fontXs,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _NetBox extends StatelessWidget {
  final AsyncValue<double> incomeAsync;
  final AsyncValue<double> expenseAsync;
  const _NetBox(
      {required this.incomeAsync, required this.expenseAsync});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(color: AppColors.separator),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.textSecondary, size: 18),
            const SizedBox(height: 4),
            Builder(builder: (context) {
              final income = incomeAsync.valueOrNull ?? 0;
              final expense = expenseAsync.valueOrNull ?? 0;
              final net = income - expense;
              return Text(net.takaSign,
                  style: TextStyle(
                      color: net.profitLossColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700));
            }),
            const Text('Net',
                style: TextStyle(
                    fontSize: AppSizes.fontXs,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ExpensePieChart extends StatefulWidget {
  final Map<String, double> data;
  const _ExpensePieChart({required this.data});

  @override
  State<_ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<_ExpensePieChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final entries = widget.data.entries.toList();
    final total = widget.data.values.fold<double>(0, (s, v) => s + v);
    final colors = AppColors.chartColors;

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response?.touchedSection == null) {
                _touched = -1;
              } else {
                _touched =
                    response!.touchedSection!.touchedSectionIndex;
              }
            });
          },
        ),
        sections: entries.asMap().entries.map((e) {
          final isTouched = e.key == _touched;
          final pct = (e.value.value / total * 100);
          return PieChartSectionData(
            color: colors[e.key % colors.length],
            value: e.value.value,
            title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
            radius: isTouched ? 80 : 65,
            titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  final Map<String, double> data;
  const _CategoryLegend({required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<double>(0, (s, v) => s + v);
    final colors = AppColors.chartColors;
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: entries.asMap().entries.map((e) {
        final pct = (e.value.value / total * 100);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors[e.key % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${e.value.key} ${pct.toStringAsFixed(0)}%',
              style: const TextStyle(
                  fontSize: AppSizes.fontXs,
                  color: AppColors.textSecondary),
            ),
          ],
        );
      }).toList(),
    );
  }
}
