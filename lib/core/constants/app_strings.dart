class AppStrings {
  AppStrings._();

  static const String appName = 'TakaTrack';
  static const String tagline = 'Your Financial Command Center';
  static const String currency = '৳';
  static const String currencyCode = 'BDT';

  // ── Nav labels ──────────────────────────────────────────────────────
  static const String navDashboard = 'Dashboard';
  static const String navExpenses = 'Expenses';
  static const String navIncome = 'Income';
  static const String navInvestments = 'Invest';
  static const String navMore = 'More';

  // ── Section titles ──────────────────────────────────────────────────
  static const String netWorth = 'Net Worth';
  static const String totalCash = 'Total Cash';
  static const String totalBank = 'Bank Balance';
  static const String totalInvestments = 'Investments';
  static const String monthlyIncome = 'Income';
  static const String monthlyExpense = 'Expenses';
  static const String monthlySavings = 'Savings';
  static const String savingsRate = 'Savings Rate';
  static const String financialHealth = 'Financial Health';
  static const String assetAllocation = 'Asset Allocation';
  static const String recentTransactions = 'Recent Transactions';

  // ── Modules ─────────────────────────────────────────────────────────
  static const String cash = 'Cash';
  static const String bankAccounts = 'Bank Accounts';
  static const String dps = 'DPS';
  static const String fdr = 'FDR';
  static const String sanchayapatra = 'Sanchayapatra';
  static const String budget = 'Budget';
  static const String reports = 'Reports';
  static const String settings = 'Settings';

  // ── Expense categories ───────────────────────────────────────────────
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Rent',
    'Utilities',
    'Shopping',
    'Mobile Recharge',
    'Internet',
    'Medical',
    'Education',
    'Family',
    'Entertainment',
    'Travel',
    'Others',
  ];

  // ── Income sources ───────────────────────────────────────────────────
  static const List<String> incomeSources = [
    'Salary',
    'Freelancing',
    'Business',
    'Rental Income',
    'Bonus',
    'Investment Profit',
    'Other',
  ];

  // ── Payment methods ──────────────────────────────────────────────────
  static const List<String> paymentMethods = [
    'Cash',
    'bKash',
    'Nagad',
    'Rocket',
    'Debit Card',
    'Credit Card',
    'Bank Transfer',
    'Other',
  ];

  // ── Investment types ─────────────────────────────────────────────────
  static const List<String> investmentTypes = [
    'Stocks',
    'Mutual Funds',
    'Gold',
    'Real Estate',
    'Business',
    'Cryptocurrency',
    'Foreign Investment',
    'Other',
  ];

  // ── Sanchayapatra schemes ────────────────────────────────────────────
  static const List<String> sanchayapatraSchemes = [
    'Family Sanchayapatra',
    'Pensioner Sanchayapatra',
    '3-Month Profit Based',
    'National Savings Certificate',
  ];

  // ── Sanchayapatra profit rates (%) ──────────────────────────────────
  static const Map<String, double> sanchayapatraRates = {
    'Family Sanchayapatra': 11.52,
    'Pensioner Sanchayapatra': 11.76,
    '3-Month Profit Based': 11.28,
    'National Savings Certificate': 11.28,
  };

  // ── Budget categories ────────────────────────────────────────────────
  static const List<String> budgetCategories = [
    'Food',
    'Transport',
    'Rent',
    'Utilities',
    'Shopping',
    'Mobile Recharge',
    'Internet',
    'Medical',
    'Education',
    'Family',
    'Entertainment',
    'Travel',
    'Others',
  ];

  // ── Cash account types ───────────────────────────────────────────────
  static const List<String> cashAccountTypes = [
    'Cash in Hand',
    'Personal Wallet',
    'Emergency Fund',
  ];

  // ── Common ──────────────────────────────────────────────────────────
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String noData = 'No data yet';
  static const String loading = 'Loading...';
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String thisMonth = 'This Month';
  static const String thisYear = 'This Year';
  static const String deleteConfirmTitle = 'Delete?';
  static const String deleteConfirmMsg =
      'This action cannot be undone. Are you sure?';
}
