import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/repositories/loan_repository.dart';

final loanStreamProvider = StreamProvider.autoDispose<List<LoanModel>>((ref) {
  return ref.watch(loanRepositoryProvider).watchAll();
});

final lentStreamProvider = StreamProvider.autoDispose<List<LoanModel>>((ref) {
  return ref.watch(loanRepositoryProvider).watchByType('lent');
});

final borrowedStreamProvider =
    StreamProvider.autoDispose<List<LoanModel>>((ref) {
  return ref.watch(loanRepositoryProvider).watchByType('borrowed');
});

class LoanNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(LoanModel model) async {
    await ref.read(loanRepositoryProvider).add(model);
  }

  Future<void> save(LoanModel model) async {
    await ref.read(loanRepositoryProvider).update(model);
  }

  Future<void> settle(int id) async {
    await ref.read(loanRepositoryProvider).settle(id);
  }

  Future<void> delete(int id) async {
    await ref.read(loanRepositoryProvider).delete(id);
  }
}

final loanNotifierProvider =
    AsyncNotifierProvider<LoanNotifier, void>(LoanNotifier.new);
