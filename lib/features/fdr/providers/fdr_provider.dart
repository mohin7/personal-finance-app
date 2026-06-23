import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/fdr_model.dart';
import '../../../data/repositories/fdr_repository.dart';

final fdrStreamProvider =
    StreamProvider.autoDispose<List<FdrModel>>((ref) {
  return ref.read(fdrRepositoryProvider).watchAll();
});

class FdrNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(FdrModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(fdrRepositoryProvider).add(model);
    ref.invalidate(fdrStreamProvider);
  }

  Future<void> save(FdrModel model) async {
    await ref.read(fdrRepositoryProvider).update(model);
    ref.invalidate(fdrStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(fdrRepositoryProvider).delete(id);
    ref.invalidate(fdrStreamProvider);
  }
}

final fdrNotifierProvider =
    AsyncNotifierProvider<FdrNotifier, void>(FdrNotifier.new);
