import 'package:isar/isar.dart';

part 'loan_model.g.dart';

@collection
class LoanModel {
  Id id = Isar.autoIncrement;

  late String type; // 'lent' | 'borrowed'

  @Index()
  late String personName;

  late double amount;

  @Index(type: IndexType.value)
  late DateTime date;

  String? note;

  bool isSettled = false;
  DateTime? settledDate;

  late DateTime createdAt;
  DateTime? updatedAt;

  bool get isLent => type == 'lent';
}
