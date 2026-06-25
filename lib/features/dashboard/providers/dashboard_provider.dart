import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../data/repositories/cash_repository.dart';
import '../../../data/repositories/bank_repository.dart';
import '../../../data/repositories/dps_repository.dart';
import '../../../data/repositories/fdr_repository.dart';
import '../../../data/repositories/sanchayapatra_repository.dart';
import '../../../data/repositories/investment_repository.dart';
import '../../../core/utils/financial_calculator.dart';

class DashboardSummary {
  final double totalCash;
  final double totalBank;
  final double totalDps;
  final double totalFdr;
  final double totalSanchayapatra;
  final double totalInvestments;
  final double monthlyIncome;
  final double monthlyExpense;
  final double totalIncome;
  final double totalExpense;

  const DashboardSummary({
    this.totalCash = 0,
    this.totalBank = 0,
    this.totalDps = 0,
    this.totalFdr = 0,
    this.totalSanchayapatra = 0,
    this.totalInvestments = 0,
    this.monthlyIncome = 0,
    this.monthlyExpense = 0,
    this.totalIncome = 0,
    this.totalExpense = 0,
  });

  double get netWorth =>
      totalCash + totalBank + totalDps + totalFdr + totalSanchayapatra + totalInvestments;

  double get monthlySavings => monthlyIncome - monthlyExpense;

  double get savingsRate => FinancialCalculator.savingsRate(
        income: monthlyIncome,
        expenses: monthlyExpense,
      );

  double get healthScore => FinancialCalculator.healthScore(
        savingsRatePercent: savingsRate,
        totalInvestments: totalInvestments,
        totalSavingsInstruments: totalDps + totalFdr + totalSanchayapatra,
        netWorth: netWorth,
        monthlyExpenses: monthlyExpense,
      );

  double get totalSavingsInstruments => totalDps + totalFdr + totalSanchayapatra;
}

final dashboardProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final now = DateTime.now();
  final year = now.year;
  final month = now.month;

  final results = await Future.wait([
    ref.read(cashRepositoryProvider).totalBalance(),
    ref.read(bankRepositoryProvider).totalBalance(),
    ref.read(dpsRepositoryProvider).totalCurrentValue(),
    ref.read(fdrRepositoryProvider).totalCurrentValue(),
    ref.read(sanchayapatraRepositoryProvider).totalCurrentValue(),
    ref.read(investmentRepositoryProvider).totalCurrentValue(),
    ref.read(incomeRepositoryProvider).totalByMonth(year, month),
    ref.read(expenseRepositoryProvider).totalByMonth(year, month),
    ref.read(incomeRepositoryProvider).totalAll(),
    ref.read(expenseRepositoryProvider).totalAll(),
  ]);

  return DashboardSummary(
    totalCash: results[0],
    totalBank: results[1],
    totalDps: results[2],
    totalFdr: results[3],
    totalSanchayapatra: results[4],
    totalInvestments: results[5],
    monthlyIncome: results[6],
    monthlyExpense: results[7],
    totalIncome: results[8],
    totalExpense: results[9],
  );
});

// ── Today's activity feed ─────────────────────────────────────────────────────

class TodayActivity {
  final String type; // 'expense' | 'income'
  final String label;
  final double amount;
  final DateTime time;
  const TodayActivity({
    required this.type,
    required this.label,
    required this.amount,
    required this.time,
  });
}

final allActivityProvider =
    FutureProvider.autoDispose<List<TodayActivity>>((ref) async {
  final expenses = await ref.read(expenseRepositoryProvider).getAll();
  final incomes = await ref.read(incomeRepositoryProvider).getAll();

  final items = <TodayActivity>[
    ...expenses.map((e) => TodayActivity(
        type: 'expense', label: e.category, amount: e.amount, time: e.date)),
    ...incomes.map((i) => TodayActivity(
        type: 'income', label: i.source, amount: i.amount, time: i.date)),
  ];
  items.sort((a, b) => b.time.compareTo(a.time));
  return items;
});

// ── 7-day expense/income trend ───────────────────────────────────────────────

class TrendData {
  final List<double> expenses;
  final List<double> incomes;
  final List<DateTime> dates;
  TrendData(this.expenses, this.incomes, this.dates);
}

final trendProvider = FutureProvider.autoDispose<TrendData>((ref) async {
  final now = DateTime.now();
  final expenses = <double>[];
  final incomes = <double>[];
  final dates = <DateTime>[];

  for (int i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59);

    final dayExpenses = await ref
        .read(expenseRepositoryProvider)
        .getByDateRange(start, end);
    final dayIncomes = await ref
        .read(incomeRepositoryProvider)
        .getByDateRange(start, end);

    expenses.add(dayExpenses.fold<double>(0, (s, e) => s + e.amount));
    incomes.add(dayIncomes.fold<double>(0, (s, e) => s + e.amount));
    dates.add(day);
  }
  return TrendData(expenses, incomes, dates);
});
