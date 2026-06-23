import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/income_model.dart';
import '../../../data/repositories/income_repository.dart';

final incomeStreamProvider =
    StreamProvider.autoDispose<List<IncomeModel>>((ref) {
  return ref.read(incomeRepositoryProvider).watchAll();
});

enum IncomeFilter { all, today, thisMonth }

final incomeFilterProvider =
    StateProvider<IncomeFilter>((ref) => IncomeFilter.thisMonth);

final filteredIncomesProvider =
    FutureProvider.autoDispose<List<IncomeModel>>((ref) async {
  final filter = ref.watch(incomeFilterProvider);
  final repo = ref.read(incomeRepositoryProvider);
  final now = DateTime.now();

  switch (filter) {
    case IncomeFilter.today:
      return repo.getToday();
    case IncomeFilter.thisMonth:
      return repo.getByMonth(now.year, now.month);
    case IncomeFilter.all:
      return repo.getAll();
  }
});

class IncomeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> add(IncomeModel model) async {
    model.createdAt = DateTime.now();
    await ref.read(incomeRepositoryProvider).add(model);
    ref.invalidate(incomeStreamProvider);
    ref.invalidate(filteredIncomesProvider);
  }

  Future<void> save(IncomeModel model) async {
    await ref.read(incomeRepositoryProvider).update(model);
    ref.invalidate(incomeStreamProvider);
    ref.invalidate(filteredIncomesProvider);
  }

  Future<void> delete(int id) async {
    await ref.read(incomeRepositoryProvider).delete(id);
    ref.invalidate(incomeStreamProvider);
    ref.invalidate(filteredIncomesProvider);
  }
}

final incomeNotifierProvider =
    AsyncNotifierProvider<IncomeNotifier, void>(IncomeNotifier.new);
