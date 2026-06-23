import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/fdr_model.dart';
import '../../shared/providers/isar_provider.dart';
import '../../core/utils/financial_calculator.dart';

final fdrRepositoryProvider = Provider<FdrRepository>((ref) {
  return FdrRepository(ref.read(isarProvider));
});

class FdrRepository {
  final Isar _isar;
  FdrRepository(this._isar);

  Future<List<FdrModel>> getAll() =>
      _isar.fdrModels.where().findAll();

  Future<List<FdrModel>> getActive() =>
      _isar.fdrModels.filter().isActiveEqualTo(true).findAll();

  Future<double> totalCurrentValue() async {
    final list = await getActive();
    return list.fold<double>(0.0, (s, f) => s + FinancialCalculator.fdrCurrentValue(
          principal: f.principalAmount,
          annualRate: f.interestRate,
          startDate: f.startDate,
        ));
  }

  Stream<List<FdrModel>> watchAll() =>
      _isar.fdrModels.where().watch(fireImmediately: true);

  Future<void> add(FdrModel model) =>
      _isar.writeTxn(() => _isar.fdrModels.put(model));

  Future<void> update(FdrModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.fdrModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.fdrModels.delete(id));

  Future<FdrModel?> getById(int id) => _isar.fdrModels.get(id);
}
