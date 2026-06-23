import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense_model.dart';
import '../models/income_model.dart';
import '../models/cash_account_model.dart';
import '../models/bank_account_model.dart';
import '../models/dps_model.dart';
import '../models/fdr_model.dart';
import '../models/sanchayapatra_model.dart';
import '../models/investment_model.dart';
import '../models/budget_model.dart';

class IsarService {
  static Future<Isar> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [
        ExpenseModelSchema,
        IncomeModelSchema,
        CashAccountModelSchema,
        CashTransactionModelSchema,
        BankAccountModelSchema,
        DpsModelSchema,
        FdrModelSchema,
        SanchayapatraModelSchema,
        InvestmentModelSchema,
        BudgetModelSchema,
      ],
      directory: dir.path,
      name: 'takatrack',
    );
  }
}
