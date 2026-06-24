import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/loan_model.dart';
import '../../shared/providers/isar_provider.dart';

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepository(ref.read(isarProvider));
});

class LoanRepository {
  final Isar _isar;
  LoanRepository(this._isar);

  Stream<List<LoanModel>> watchAll() =>
      _isar.loanModels.where().watch(fireImmediately: true);

  Stream<List<LoanModel>> watchByType(String type) => _isar.loanModels
      .filter()
      .typeEqualTo(type)
      .watch(fireImmediately: true);

  Future<List<LoanModel>> getAll() => _isar.loanModels.where().findAll();

  Future<LoanModel?> getById(int id) => _isar.loanModels.get(id);

  Future<void> add(LoanModel model) =>
      _isar.writeTxn(() => _isar.loanModels.put(model));

  Future<void> update(LoanModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.loanModels.put(model));
  }

  Future<void> settle(int id) async {
    final loan = await _isar.loanModels.get(id);
    if (loan != null) {
      loan.isSettled = true;
      loan.settledDate = DateTime.now();
      loan.updatedAt = DateTime.now();
      await _isar.writeTxn(() => _isar.loanModels.put(loan));
    }
  }

  Future<void> delete(int id) =>
      _isar.writeTxn(() => _isar.loanModels.delete(id));
}
