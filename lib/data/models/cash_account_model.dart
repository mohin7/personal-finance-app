import 'package:isar/isar.dart';

part 'cash_account_model.g.dart';

@collection
class CashAccountModel {
  Id id = Isar.autoIncrement;

  late String name;
  late String type; // 'Cash in Hand', 'Personal Wallet', 'Emergency Fund'
  late double balance;
  late DateTime createdAt;
  DateTime? updatedAt;
}

@collection
class CashTransactionModel {
  Id id = Isar.autoIncrement;

  late int cashAccountId;

  @Index(type: IndexType.value)
  late DateTime date;

  late double amount;
  late String type; // 'deposit', 'withdrawal', 'transfer'
  String? description;
  late DateTime createdAt;
}
