import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/income_model.dart';
import '../../../data/repositories/income_repository.dart';

// ── Live stream of all income from Isar ──────────────────────────────────────

final incomeStreamProvider =
    StreamProvider<List<IncomeModel>>((ref) {
  return ref.read(incomeRepositoryProvider).watchAll();
});

// ── Filter state ─────────────────────────────────────────────────────────────

enum IncomeFilter { all, today, thisWeek, thisMonth }

final incomeFilterProvider =
    StateProvider<IncomeFilter>((ref) => IncomeFilter.all);

// ── Derived filtered list — reactive via incomeStreamProvider ────────────────

final filteredIncomesProvider =
    Provider.autoDispose<AsyncValue<List<IncomeModel>>>((ref) {
  final allAsync = ref.watch(incomeStreamProvider);
  final filter = ref.watch(incomeFilterProvider);
  final now = DateTime.now();

  return allAsync.whenData((all) {
    switch (filter) {
      case IncomeFilter.today:
        final start = DateTime(now.year, now.month, now.day);
        final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        return all
            .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
            .toList();
      case IncomeFilter.thisWeek:
        final daysBack = now.weekday - 1;
        final start = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: daysBack));
        final end = start
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
        return all
            .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
            .toList();
      case IncomeFilter.thisMonth:
        return all
            .where((e) =>
                e.date.year == now.year && e.date.month == now.month)
            .toList();
      case IncomeFilter.all:
        return all;
    }
  });
});

// ── CRUD notifier ─────────────────────────────────────────────────────────────

class IncomeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(IncomeModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(incomeRepositoryProvider).add(model);
    ref.invalidate(incomeStreamProvider);
  }

  Future<void> save(IncomeModel model) async {
    await ref.read(incomeRepositoryProvider).update(model);
    ref.invalidate(incomeStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(incomeRepositoryProvider).delete(id);
    ref.invalidate(incomeStreamProvider);
  }
}

final incomeNotifierProvider =
    AsyncNotifierProvider<IncomeNotifier, void>(IncomeNotifier.new);
