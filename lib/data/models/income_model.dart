import 'package:isar/isar.dart';

part 'income_model.g.dart';

@collection
class IncomeModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late DateTime date;

  late double amount;

  @Index()
  late String source;

  String? notes;

  late DateTime createdAt;
  DateTime? updatedAt;
}
