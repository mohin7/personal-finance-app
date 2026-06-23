import 'package:isar/isar.dart';

part 'bank_account_model.g.dart';

@collection
class BankAccountModel {
  Id id = Isar.autoIncrement;

  late String bankName;
  late String accountName;
  late String accountNumber;
  late double balance;
  String? branchName;
  String? notes;
  late DateTime createdAt;
  DateTime? updatedAt;
}
