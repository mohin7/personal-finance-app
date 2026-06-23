import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/investment_model.dart';
import '../../../data/repositories/investment_repository.dart';

final investmentStreamProvider =
    StreamProvider.autoDispose<List<InvestmentModel>>((ref) {
  return ref.read(investmentRepositoryProvider).watchAll();
});

final investmentsByTypeProvider =
    FutureProvider.autoDispose.family<List<InvestmentModel>, String>(
  (ref, type) => ref.read(investmentRepositoryProvider).getByType(type),
);

class InvestmentNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(InvestmentModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(investmentRepositoryProvider).add(model);
    ref.invalidate(investmentStreamProvider);
  }

  Future<void> save(InvestmentModel model) async {
    await ref.read(investmentRepositoryProvider).update(model);
    ref.invalidate(investmentStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(investmentRepositoryProvider).delete(id);
    ref.invalidate(investmentStreamProvider);
  }
}

final investmentNotifierProvider =
    AsyncNotifierProvider<InvestmentNotifier, void>(InvestmentNotifier.new);
