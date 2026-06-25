import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/expense_repository.dart';

// ── Live stream of all expenses from Isar ────────────────────────────────────

final expenseStreamProvider =
    StreamProvider<List<ExpenseModel>>((ref) {
  return ref.read(expenseRepositoryProvider).watchAll();
});

// ── Filter state ─────────────────────────────────────────────────────────────

enum ExpenseFilter { all, today, thisWeek, thisMonth }

final expenseFilterProvider =
    StateProvider<ExpenseFilter>((ref) => ExpenseFilter.all);

final expenseSearchProvider = StateProvider<String>((ref) => '');

// ── Derived filtered list — reactive via expenseStreamProvider ───────────────
// Uses in-memory filtering so the live stream drives all updates automatically.

final filteredExpensesProvider =
    Provider.autoDispose<AsyncValue<List<ExpenseModel>>>((ref) {
  final allAsync = ref.watch(expenseStreamProvider);
  final filter = ref.watch(expenseFilterProvider);
  final search = ref.watch(expenseSearchProvider).toLowerCase();
  final now = DateTime.now();

  return allAsync.whenData((all) {
    List<ExpenseModel> list;
    switch (filter) {
      case ExpenseFilter.today:
        final start = DateTime(now.year, now.month, now.day);
        final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        list = all
            .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
            .toList();
        break;
      case ExpenseFilter.thisWeek:
        final daysBack = now.weekday - 1;
        final start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: daysBack));
        final end = start
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
        list = all
            .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
            .toList();
        break;
      case ExpenseFilter.thisMonth:
        list = all
            .where((e) =>
                e.date.year == now.year && e.date.month == now.month)
            .toList();
        break;
      case ExpenseFilter.all:
        list = all;
    }
    if (search.isEmpty) return list;
    return list
        .where((e) =>
            e.category.toLowerCase().contains(search) ||
            (e.note?.toLowerCase().contains(search) ?? false))
        .toList();
  });
});

// ── CRUD notifier ─────────────────────────────────────────────────────────────

class ExpenseNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(ExpenseModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(expenseRepositoryProvider).add(model);
    ref.invalidate(expenseStreamProvider);
  }

  Future<void> save(ExpenseModel model) async {
    await ref.read(expenseRepositoryProvider).update(model);
    ref.invalidate(expenseStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(expenseRepositoryProvider).delete(id);
    ref.invalidate(expenseStreamProvider);
  }
}

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, void>(ExpenseNotifier.new);
