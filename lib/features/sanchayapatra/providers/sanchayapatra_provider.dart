import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/sanchayapatra_model.dart';
import '../../../data/repositories/sanchayapatra_repository.dart';

final sanchayapatraStreamProvider =
    StreamProvider.autoDispose<List<SanchayapatraModel>>((ref) {
  return ref.read(sanchayapatraRepositoryProvider).watchAll();
});

class SanchayapatraNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(SanchayapatraModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(sanchayapatraRepositoryProvider).add(model);
    ref.invalidate(sanchayapatraStreamProvider);
  }

  Future<void> save(SanchayapatraModel model) async {
    await ref.read(sanchayapatraRepositoryProvider).update(model);
    ref.invalidate(sanchayapatraStreamProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(sanchayapatraRepositoryProvider).delete(id);
    ref.invalidate(sanchayapatraStreamProvider);
  }
}

final sanchayapatraNotifierProvider =
    AsyncNotifierProvider<SanchayapatraNotifier, void>(
        SanchayapatraNotifier.new);
