import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/dps_model.dart';
import '../../../data/repositories/dps_repository.dart';

final dpsStreamProvider =
    StreamProvider.autoDispose<List<DpsModel>>((ref) {
  return ref.read(dpsRepositoryProvider).watchAll();
});

class DpsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(DpsModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(dpsRepositoryProvider).add(model);
    ref.invalidate(dpsStreamProvider);
  }

  Future<void> save(DpsModel model) async {
    await ref.read(dpsRepositoryProvider).update(model);
    ref.invalidate(dpsStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(dpsRepositoryProvider).delete(id);
    ref.invalidate(dpsStreamProvider);
  }
}

final dpsNotifierProvider =
    AsyncNotifierProvider<DpsNotifier, void>(DpsNotifier.new);
