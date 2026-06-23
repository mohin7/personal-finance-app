import 'package:isar/isar.dart';

part 'budget_model.g.dart';

@collection
class BudgetModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String category;

  late double allocatedAmount;
  late double spentAmount;

  @Index()
  late int month; // 1–12

  @Index()
  late int year;

  late DateTime createdAt;
  DateTime? updatedAt;

  double get remainingAmount => allocatedAmount - spentAmount;
  double get usedPercent =>
      allocatedAmount > 0 ? (spentAmount / allocatedAmount) * 100 : 0;
  bool get isOverBudget => spentAmount > allocatedAmount;
}
