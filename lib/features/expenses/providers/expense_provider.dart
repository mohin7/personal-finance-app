import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/expense_repository.dart';

// ── List (stream) ────────────────────────────────────────────────────────────

final expenseStreamProvider =
    StreamProvider.autoDispose<List<ExpenseModel>>((ref) {
  return ref.read(expenseRepositoryProvider).watchAll();
});

// ── Filter state ─────────────────────────────────────────────────────────────

enum ExpenseFilter { all, today, thisMonth }

final expenseFilterProvider =
    StateProvider<ExpenseFilter>((ref) => ExpenseFilter.thisMonth);

final expenseSearchProvider = StateProvider<String>((ref) => '');

final filteredExpensesProvider =
    FutureProvider.autoDispose<List<ExpenseModel>>((ref) async {
  final filter = ref.watch(expenseFilterProvider);
  final search = ref.watch(expenseSearchProvider).toLowerCase();
  final repo = ref.read(expenseRepositoryProvider);
  final now = DateTime.now();

  List<ExpenseModel> list;
  switch (filter) {
    case ExpenseFilter.today:
      list = await repo.getToday();
      break;
    case ExpenseFilter.thisMonth:
      list = await repo.getByMonth(now.year, now.month);
      break;
    case ExpenseFilter.all:
      list = await repo.getAll();
  }

  if (search.isEmpty) return list;
  return list
      .where((e) =>
          e.category.toLowerCase().contains(search) ||
          (e.note?.toLowerCase().contains(search) ?? false))
      .toList();
});

// ── CRUD notifier ─────────────────────────────────────────────────────────────

class ExpenseNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(ExpenseModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(expenseRepositoryProvider).add(model);
    ref.invalidate(expenseStreamProvider);
    ref.invalidate(filteredExpensesProvider);
  }

  Future<void> save(ExpenseModel model) async {
    await ref.read(expenseRepositoryProvider).update(model);
    ref.invalidate(expenseStreamProvider);
    ref.invalidate(filteredExpensesProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(expenseRepositoryProvider).delete(id);
    ref.invalidate(expenseStreamProvider);
    ref.invalidate(filteredExpensesProvider);
  }
}

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, void>(ExpenseNotifier.new);
