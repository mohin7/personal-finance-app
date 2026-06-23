import 'package:isar/isar.dart';

part 'sanchayapatra_model.g.dart';

@collection
class SanchayapatraModel {
  Id id = Isar.autoIncrement;

  late String schemeName;
  late double purchaseAmount;
  late double profitRate;

  @Index(type: IndexType.value)
  late DateTime purchaseDate;

  late DateTime maturityDate;
  late bool isActive;
  String? notes;
  late DateTime createdAt;
  DateTime? updatedAt;
}
