import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/sanchayapatra_model.dart';
import '../../shared/providers/isar_provider.dart';
import '../../core/utils/financial_calculator.dart';

final sanchayapatraRepositoryProvider =
    Provider<SanchayapatraRepository>((ref) {
  return SanchayapatraRepository(ref.read(isarProvider));
});

class SanchayapatraRepository {
  final Isar _isar;
  SanchayapatraRepository(this._isar);

  Future<List<SanchayapatraModel>> getAll() =>
      _isar.sanchayapatraModels.where().findAll();

  Future<List<SanchayapatraModel>> getActive() =>
      _isar.sanchayapatraModels.filter().isActiveEqualTo(true).findAll();

  Future<double> totalCurrentValue() async {
    final list = await getActive();
    return list.fold<double>(
      0.0,
      (s, sp) => s + FinancialCalculator.sanchayapatraCurrentValue(
            purchaseAmount: sp.purchaseAmount,
            annualProfitRate: sp.profitRate,
            purchaseDate: sp.purchaseDate,
          ),
    );
  }

  Stream<List<SanchayapatraModel>> watchAll() =>
      _isar.sanchayapatraModels.where().watch(fireImmediately: true);

  Future<void> add(SanchayapatraModel model) =>
      _isar.writeTxn(() => _isar.sanchayapatraModels.put(model));

  Future<void> update(SanchayapatraModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.sanchayapatraModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.sanchayapatraModels.delete(id));

  Future<SanchayapatraModel?> getById(int id) =>
      _isar.sanchayapatraModels.get(id);
}
