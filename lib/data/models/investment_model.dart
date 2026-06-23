import 'package:isar/isar.dart';

part 'investment_model.g.dart';

@collection
class InvestmentModel {
  Id id = Isar.autoIncrement;

  late String name;

  @Index()
  late String type;

  late double investedAmount;
  late double currentValue;

  @Index(type: IndexType.value)
  late DateTime purchaseDate;

  String? notes;
  late DateTime createdAt;
  DateTime? updatedAt;
}
