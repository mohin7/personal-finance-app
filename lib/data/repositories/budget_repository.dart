import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/budget_model.dart';
import '../../shared/providers/isar_provider.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.read(isarProvider));
});

class BudgetRepository {
  final Isar _isar;
  BudgetRepository(this._isar);

  Future<List<BudgetModel>> getByMonth(int year, int month) =>
      _isar.budgetModels
          .filter()
          .yearEqualTo(year)
          .monthEqualTo(month)
          .findAll();

  Future<BudgetModel?> getByCategory(
          int year, int month, String category) =>
      _isar.budgetModels
          .filter()
          .yearEqualTo(year)
          .monthEqualTo(month)
          .categoryEqualTo(category)
          .findFirst();

  Stream<List<BudgetModel>> watchByMonth(int year, int month) =>
      _isar.budgetModels
          .filter()
          .yearEqualTo(year)
          .monthEqualTo(month)
          .watch(fireImmediately: true);

  Future<void> add(BudgetModel model) =>
      _isar.writeTxn(() => _isar.budgetModels.put(model));

  Future<void> update(BudgetModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.budgetModels.put(model));
  }

  Future<void> updateSpent(int id, double spent) async {
    final budget = await _isar.budgetModels.get(id);
    if (budget != null) {
      budget.spentAmount = spent;
      budget.updatedAt = DateTime.now();
      await _isar.writeTxn(() => _isar.budgetModels.put(budget));
    }
  }

  Future<BudgetModel?> getById(int id) => _isar.budgetModels.get(id);

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.budgetModels.delete(id));
}
