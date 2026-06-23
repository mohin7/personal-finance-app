import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/dps_model.dart';
import '../../shared/providers/isar_provider.dart';
import '../../core/utils/financial_calculator.dart';

final dpsRepositoryProvider = Provider<DpsRepository>((ref) {
  return DpsRepository(ref.read(isarProvider));
});

class DpsRepository {
  final Isar _isar;
  DpsRepository(this._isar);

  Future<List<DpsModel>> getAll() =>
      _isar.dpsModels.where().findAll();

  Future<List<DpsModel>> getActive() =>
      _isar.dpsModels.filter().isActiveEqualTo(true).findAll();

  Future<double> totalCurrentValue() async {
    final list = await getActive();
    return list.fold<double>(0.0, (s, d) => s + FinancialCalculator.dpsCurrentValue(
          monthlyDeposit: d.monthlyDeposit,
          annualRate: d.interestRate,
          startDate: d.startDate,
        ));
  }

  Stream<List<DpsModel>> watchAll() =>
      _isar.dpsModels.where().watch(fireImmediately: true);

  Future<void> add(DpsModel model) =>
      _isar.writeTxn(() => _isar.dpsModels.put(model));

  Future<void> update(DpsModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.dpsModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.dpsModels.delete(id));

  Future<DpsModel?> getById(int id) => _isar.dpsModels.get(id);
}
