import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/expenses/presentation/expenses_screen.dart';
import '../../features/expenses/presentation/add_expense_screen.dart';
import '../../features/income/presentation/income_screen.dart';
import '../../features/income/presentation/add_income_screen.dart';
import '../../features/investments/presentation/investments_screen.dart';
import '../../features/investments/presentation/add_investment_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/cash/presentation/cash_screen.dart';
import '../../features/cash/presentation/add_cash_transaction_screen.dart';
import '../../features/banks/presentation/banks_screen.dart';
import '../../features/banks/presentation/add_bank_screen.dart';
import '../../features/dps/presentation/dps_screen.dart';
import '../../features/dps/presentation/add_dps_screen.dart';
import '../../features/fdr/presentation/fdr_screen.dart';
import '../../features/fdr/presentation/add_fdr_screen.dart';
import '../../features/sanchayapatra/presentation/sanchayapatra_screen.dart';
import '../../features/sanchayapatra/presentation/add_sanchayapatra_screen.dart';
import '../../features/budgets/presentation/budgets_screen.dart';
import '../../features/budgets/presentation/add_budget_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/loans/presentation/loans_screen.dart';
import '../../features/loans/presentation/add_loan_screen.dart';
import '../../shared/widgets/shell_scaffold.dart';

class AppRoutes {
  static const dashboard = '/';
  static const expenses = '/expenses';
  static const addExpense = '/expenses/add';
  static const editExpense = '/expenses/edit/:id';
  static const income = '/income';
  static const addIncome = '/income/add';
  static const editIncome = '/income/edit/:id';
  static const investments = '/investments';
  static const addInvestment = '/investments/add';
  static const editInvestment = '/investments/edit/:id';
  static const more = '/more';
  static const cash = '/cash';
  static const addCashTransaction = '/cash/add';
  static const banks = '/banks';
  static const addBank = '/banks/add';
  static const editBank = '/banks/edit/:id';
  static const dps = '/dps';
  static const addDps = '/dps/add';
  static const editDps = '/dps/edit/:id';
  static const fdr = '/fdr';
  static const addFdr = '/fdr/add';
  static const editFdr = '/fdr/edit/:id';
  static const sanchayapatra = '/sanchayapatra';
  static const addSanchayapatra = '/sanchayapatra/add';
  static const editSanchayapatra = '/sanchayapatra/edit/:id';
  static const budgets = '/budgets';
  static const addBudget = '/budgets/add';
  static const reports = '/reports';
  static const settings = '/settings';
  static const loans = '/loans';
  static const addLoan = '/loans/add';
  static const editLoan = '/loans/edit/:id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (ctx, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (ctx, s) =>
                _slide(const DashboardScreen(), s),
          ),
          GoRoute(
            path: AppRoutes.expenses,
            pageBuilder: (ctx, s) =>
                _slide(const ExpensesScreen(), s),
          ),
          GoRoute(
            path: AppRoutes.income,
            pageBuilder: (ctx, s) =>
                _slide(const IncomeScreen(), s),
          ),
          GoRoute(
            path: AppRoutes.investments,
            pageBuilder: (ctx, s) =>
                _slide(const InvestmentsScreen(), s),
          ),
          GoRoute(
            path: AppRoutes.more,
            pageBuilder: (ctx, s) =>
                _slide(const MoreScreen(), s),
          ),
        ],
      ),

      // ── Expenses ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.addExpense,
        builder: (ctx, s) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: AppRoutes.editExpense,
        builder: (ctx, s) =>
            AddExpenseScreen(editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── Income ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.addIncome,
        builder: (ctx, s) => const AddIncomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.editIncome,
        builder: (ctx, s) =>
            AddIncomeScreen(editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── Investments ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.addInvestment,
        builder: (ctx, s) => const AddInvestmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.editInvestment,
        builder: (ctx, s) =>
            AddInvestmentScreen(editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── Cash ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.cash,
        builder: (ctx, s) => const CashScreen(),
      ),
      GoRoute(
        path: AppRoutes.addCashTransaction,
        builder: (ctx, s) => const AddCashTransactionScreen(),
      ),

      // ── Banks ───────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.banks,
        builder: (ctx, s) => const BanksScreen(),
      ),
      GoRoute(
        path: AppRoutes.addBank,
        builder: (ctx, s) => const AddBankScreen(),
      ),
      GoRoute(
        path: AppRoutes.editBank,
        builder: (ctx, s) =>
            AddBankScreen(editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── DPS ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.dps,
        builder: (ctx, s) => const DpsScreen(),
      ),
      GoRoute(
        path: AppRoutes.addDps,
        builder: (ctx, s) => const AddDpsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editDps,
        builder: (ctx, s) =>
            AddDpsScreen(editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── FDR ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.fdr,
        builder: (ctx, s) => const FdrScreen(),
      ),
      GoRoute(
        path: AppRoutes.addFdr,
        builder: (ctx, s) => const AddFdrScreen(),
      ),
      GoRoute(
        path: AppRoutes.editFdr,
        builder: (ctx, s) =>
            AddFdrScreen(editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── Sanchayapatra ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.sanchayapatra,
        builder: (ctx, s) => const SanchayapatraScreen(),
      ),
      GoRoute(
        path: AppRoutes.addSanchayapatra,
        builder: (ctx, s) => const AddSanchayapatraScreen(),
      ),
      GoRoute(
        path: AppRoutes.editSanchayapatra,
        builder: (ctx, s) => AddSanchayapatraScreen(
            editId: int.tryParse(s.pathParameters['id']!)),
      ),

      // ── Budgets ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.budgets,
        builder: (ctx, s) => const BudgetsScreen(),
      ),
      GoRoute(
        path: AppRoutes.addBudget,
        builder: (ctx, s) => const AddBudgetScreen(),
      ),

      // ── Reports ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.reports,
        builder: (ctx, s) => const ReportsScreen(),
      ),

      // ── Settings ─────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        builder: (ctx, s) => const SettingsScreen(),
      ),

      // ── Loans ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.loans,
        builder: (ctx, s) => const LoansScreen(),
      ),
      GoRoute(
        path: AppRoutes.addLoan,
        builder: (ctx, s) => AddLoanScreen(
          type: s.uri.queryParameters['type'] ?? 'lent',
        ),
      ),
      GoRoute(
        path: AppRoutes.editLoan,
        builder: (ctx, s) => AddLoanScreen(
          type: s.uri.queryParameters['type'] ?? 'lent',
          editId: int.tryParse(s.pathParameters['id']!),
        ),
      ),
    ],
  );
});

CustomTransitionPage<void> _slide(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (ctx, anim, secondAnim, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeOut).animate(anim),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}
