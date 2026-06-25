import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/income_model.dart';
import '../../shared/providers/isar_provider.dart';

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  return IncomeRepository(ref.read(isarProvider));
});

class IncomeRepository {
  final Isar _isar;
  IncomeRepository(this._isar);

  Future<List<IncomeModel>> getAll() =>
      _isar.incomeModels.where().sortByDateDesc().findAll();

  Future<List<IncomeModel>> getByMonth(int year, int month) {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1).subtract(const Duration(milliseconds: 1));
    return _isar.incomeModels
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<IncomeModel>> getToday() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return _isar.incomeModels
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<IncomeModel>> getByDateRange(DateTime start, DateTime end) =>
      _isar.incomeModels
          .filter()
          .dateBetween(start, end)
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

  Future<double> totalAll() async {
    final list = await getAll();
    return list.fold<double>(0.0, (s, e) => s + e.amount);
  }

  Stream<List<IncomeModel>> watchAll() =>
      _isar.incomeModels.where().sortByDateDesc().watch(fireImmediately: true);

  Future<void> add(IncomeModel model) =>
      _isar.writeTxn(() => _isar.incomeModels.put(model));

  Future<void> update(IncomeModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.incomeModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.incomeModels.delete(id));

  Future<IncomeModel?> getById(int id) => _isar.incomeModels.get(id);
}
