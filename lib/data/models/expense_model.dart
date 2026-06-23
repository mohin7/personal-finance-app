import 'package:isar/isar.dart';

part 'expense_model.g.dart';

@collection
class ExpenseModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late DateTime date;

  late double amount;

  @Index()
  late String category;

  String? note;

  late String paymentMethod;

  late DateTime createdAt;
  DateTime? updatedAt;
}
