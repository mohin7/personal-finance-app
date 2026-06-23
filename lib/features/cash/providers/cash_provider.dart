import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/cash_account_model.dart';
import '../../../data/repositories/cash_repository.dart';

final cashAccountsStreamProvider =
    StreamProvider.autoDispose<List<CashAccountModel>>((ref) {
  return ref.read(cashRepositoryProvider).watchAccounts();
});

class CashNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addAccount(CashAccountModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(cashRepositoryProvider).addAccount(model);
    ref.invalidate(cashAccountsStreamProvider);
  }

  Future<void> deposit(int accountId, double amount, String? desc) async {
    final tx = CashTransactionModel()
      ..cashAccountId = accountId
      ..amount = amount
      ..type = 'deposit'
      ..description = desc
      ..date = DateTime.now()
      ..createdAt = DateTime.now();
    await ref.read(cashRepositoryProvider).addTransaction(tx);
    ref.invalidate(cashAccountsStreamProvider);
  }

  Future<void> withdraw(int accountId, double amount, String? desc) async {
    final tx = CashTransactionModel()
      ..cashAccountId = accountId
      ..amount = amount
      ..type = 'withdrawal'
      ..description = desc
      ..date = DateTime.now()
      ..createdAt = DateTime.now();
    await ref.read(cashRepositoryProvider).addTransaction(tx);
    ref.invalidate(cashAccountsStreamProvider);
  }

  Future<void> deleteAccount(int id) async {
    await ref.read(cashRepositoryProvider).deleteAccount(id);
    ref.invalidate(cashAccountsStreamProvider);
  }
}

final cashNotifierProvider =
    AsyncNotifierProvider<CashNotifier, void>(CashNotifier.new);
