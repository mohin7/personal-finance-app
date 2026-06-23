import 'package:isar/isar.dart';

part 'fdr_model.g.dart';

@collection
class FdrModel {
  Id id = Isar.autoIncrement;

  late String bankName;
  late String fdrName;
  late double principalAmount;
  late double interestRate;

  @Index(type: IndexType.value)
  late DateTime startDate;

  late DateTime maturityDate;
  late bool isActive;
  String? notes;
  late DateTime createdAt;
  DateTime? updatedAt;
}
