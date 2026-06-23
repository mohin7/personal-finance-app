import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/bank_account_model.dart';
import '../../../data/repositories/bank_repository.dart';

final bankStreamProvider =
    StreamProvider.autoDispose<List<BankAccountModel>>((ref) {
  return ref.read(bankRepositoryProvider).watchAll();
});

class BankNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(BankAccountModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(bankRepositoryProvider).add(model);
    ref.invalidate(bankStreamProvider);
  }

  Future<void> save(BankAccountModel model) async {
    await ref.read(bankRepositoryProvider).update(model);
    ref.invalidate(bankStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(bankRepositoryProvider).delete(id);
    ref.invalidate(bankStreamProvider);
  }
}

final bankNotifierProvider =
    AsyncNotifierProvider<BankNotifier, void>(BankNotifier.new);
