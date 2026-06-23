import 'package:isar/isar.dart';

part 'dps_model.g.dart';

@collection
class DpsModel {
  Id id = Isar.autoIncrement;

  late String bankName;
  late String dpsName;
  late double monthlyDeposit;
  late double interestRate;

  @Index(type: IndexType.value)
  late DateTime startDate;

  late DateTime maturityDate;
  late bool isActive;
  String? notes;
  late DateTime createdAt;
  DateTime? updatedAt;
}
