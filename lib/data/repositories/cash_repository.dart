import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/cash_account_model.dart';
import '../../shared/providers/isar_provider.dart';

final cashRepositoryProvider = Provider<CashRepository>((ref) {
  return CashRepository(ref.read(isarProvider));
});

class CashRepository {
  final Isar _isar;
  CashRepository(this._isar);

  // ── Accounts ────────────────────────────────────────────────────────
  Future<List<CashAccountModel>> getAllAccounts() =>
      _isar.cashAccountModels.where().findAll();

  Future<double> totalBalance() async {
    final accounts = await getAllAccounts();
    return accounts.fold<double>(0.0, (s, a) => s + a.balance);
  }

  Future<void> addAccount(CashAccountModel model) =>
      _isar.writeTxn(() => _isar.cashAccountModels.put(model));

  Future<void> updateAccount(CashAccountModel model) {
    model.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.cashAccountModels.put(model));
  }

  Future<void> deleteAccount(int id) =>
      _isar.writeTxn(() => _isar.cashAccountModels.delete(id));

  Future<CashAccountModel?> getAccountById(int id) =>
      _isar.cashAccountModels.get(id);

  Stream<List<CashAccountModel>> watchAccounts() =>
      _isar.cashAccountModels.where().watch(fireImmediately: true);

  // ── Transactions ────────────────────────────────────────────────────
  Future<List<CashTransactionModel>> getTransactions(int accountId) =>
      _isar.cashTransactionModels
          .filter()
          .cashAccountIdEqualTo(accountId)
          .sortByDateDesc()
          .findAll();

  Future<void> addTransaction(CashTransactionModel tx) async {
    await _isar.writeTxn(() async {
      await _isar.cashTransactionModels.put(tx);
      final account = await _isar.cashAccountModels.get(tx.cashAccountId);
      if (account != null) {
        if (tx.type == 'deposit') {
          account.balance += tx.amount;
        } else if (tx.type == 'withdrawal') {
          account.balance -= tx.amount;
        }
        await _isar.cashAccountModels.put(account);
      }
    });
  }
}
