import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/budget_model.dart';
import '../../../data/repositories/budget_repository.dart';

final currentMonthBudgetsProvider =
    StreamProvider.autoDispose<List<BudgetModel>>((ref) {
  final now = DateTime.now();
  return ref.read(budgetRepositoryProvider).watchByMonth(now.year, now.month);
});

class BudgetNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(BudgetModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(budgetRepositoryProvider).add(model);
    ref.invalidate(currentMonthBudgetsProvider);
  }

  Future<void> save(BudgetModel model) async {
    await ref.read(budgetRepositoryProvider).update(model);
    ref.invalidate(currentMonthBudgetsProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(budgetRepositoryProvider).delete(id);
    ref.invalidate(currentMonthBudgetsProvider);
  }
}

final budgetNotifierProvider =
    AsyncNotifierProvider<BudgetNotifier, void>(BudgetNotifier.new);
