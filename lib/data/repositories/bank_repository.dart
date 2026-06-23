import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/bank_account_model.dart';
import '../../shared/providers/isar_provider.dart';

final bankRepositoryProvider = Provider<BankRepository>((ref) {
  return BankRepository(ref.read(isarProvider));
});

class BankRepository {
  final Isar _isar;
  BankRepository(this._isar);

  Future<List<BankAccountModel>> getAll() =>
      _isar.bankAccountModels.where().findAll();

  Future<double> totalBalance() async {
    final list = await getAll();
    return list.fold<double>(0.0, (s, b) => s + b.balance);
  }

  Stream<List<BankAccountModel>> watchAll() =>
      _isar.bankAccountModels.where().watch(fireImmediately: true);

  Future<void> add(BankAccountModel model) =>
      _isar.writeTxn(() => _isar.bankAccountModels.put(model));

  Future<void> update(BankAccountModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.bankAccountModels.put(model));
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.bankAccountModels.delete(id));

  Future<BankAccountModel?> getById(int id) =>
      _isar.bankAccountModels.get(id);
}
