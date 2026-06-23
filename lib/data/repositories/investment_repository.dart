import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/investment_model.dart';
import '../../shared/providers/isar_provider.dart';

final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) {
  return InvestmentRepository(ref.read(isarProvider));
});

class InvestmentRepository {
  final Isar _isar;
  InvestmentRepository(this._isar);

  Future<List<InvestmentModel>> getAll() =>
      _isar.investmentModels.where().findAll();

  Future<List<InvestmentModel>> getByType(String type) =>
      _isar.investmentModels.filter().typeEqualTo(type).findAll();

  Future<double> totalCurrentValue() async {
    final list = await getAll();
    return list.fold<double>(0.0, (s, i) => s + i.currentValue);
  }

  Future<double> totalInvested() async {
    final list = await getAll();
    return list.fold<double>(0.0, (s, i) => s + i.investedAmount);
  }

  Stream<List<InvestmentModel>> watchAll() =>
      _isar.investmentModels.where().watch(fireImmediately: true);

  Future<void> add(InvestmentModel model) =>
      _isar.writeTxn(() => _isar.investmentModels.put(model));

  Future<void> update(InvestmentModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.investmentModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.investmentModels.delete(id));

  Future<InvestmentModel?> getById(int id) => _isar.investmentModels.get(id);
}
