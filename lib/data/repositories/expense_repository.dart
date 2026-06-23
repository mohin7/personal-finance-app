import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/expense_model.dart';
import '../../shared/providers/isar_provider.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.read(isarProvider));
});

class ExpenseRepository {
  final Isar _isar;
  ExpenseRepository(this._isar);

  Future<List<ExpenseModel>> getAll() =>
      _isar.expenseModels.where().sortByDateDesc().findAll();

  Future<List<ExpenseModel>> getByMonth(int year, int month) {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1).subtract(const Duration(milliseconds: 1));
    return _isar.expenseModels
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<ExpenseModel>> getToday() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return _isar.expenseModels
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<ExpenseModel>> getByDateRange(DateTime start, DateTime end) =>
      _isar.expenseModels
          .filter()
          .dateBetween(start, end)
          .sortByDateDesc()
          .findAll();

  Future<List<ExpenseModel>> getByCategory(String category) =>
      _isar.expenseModels
          .filter()
          .categoryEqualTo(category)
          .sortByDateDesc()
          .findAll();

  Future<double> totalByMonth(int year, int month) async {
    final list = await getByMonth(year, month);
    return list.fold<double>(0.0, (s, e) => s + e.amount);
  }

  Future<double> totalToday() async {
    final list = await getToday();
    return list.fold<double>(0.0, (s, e) => s + e.amount);
  }

  Stream<List<ExpenseModel>> watchAll() =>
      _isar.expenseModels.where().sortByDateDesc().watch(fireImmediately: true);

  Future<void> add(ExpenseModel model) => _isar.writeTxn(
        () => _isar.expenseModels.put(model),
      );

  Future<void> update(ExpenseModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.expenseModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.expenseModels.delete(id));

  Future<ExpenseModel?> getById(int id) => _isar.expenseModels.get(id);
}
