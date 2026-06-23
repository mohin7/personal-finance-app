import 'dart:math';

class FinancialCalculator {
  FinancialCalculator._();

  /// FDR / Simple Interest maturity value
  static double fdrMaturityValue({
    required double principal,
    required double annualRate,
    required DateTime startDate,
    required DateTime maturityDate,
  }) {
    final days = maturityDate.difference(startDate).inDays;
    final interest = principal * (annualRate / 100) * (days / 365);
    return principal + interest;
  }

  /// FDR current accrued value
  static double fdrCurrentValue({
    required double principal,
    required double annualRate,
    required DateTime startDate,
  }) {
    final days = DateTime.now().difference(startDate).inDays;
    if (days <= 0) return principal;
    final interest = principal * (annualRate / 100) * (days / 365);
    return principal + interest;
  }

  /// DPS maturity value (future value of monthly annuity)
  static double dpsMaturityValue({
    required double monthlyDeposit,
    required double annualRate,
    required int totalMonths,
  }) {
    final r = annualRate / 100 / 12;
    if (r == 0) return monthlyDeposit * totalMonths;
    return monthlyDeposit * ((pow(1 + r, totalMonths) - 1) / r) * (1 + r);
  }

  /// DPS current value (deposits paid so far + interest)
  static double dpsCurrentValue({
    required double monthlyDeposit,
    required double annualRate,
    required DateTime startDate,
  }) {
    final monthsElapsed = _monthsElapsed(startDate, DateTime.now());
    if (monthsElapsed <= 0) return 0;
    final r = annualRate / 100 / 12;
    if (r == 0) return monthlyDeposit * monthsElapsed;
    return monthlyDeposit *
        ((pow(1 + r, monthsElapsed) - 1) / r) *
        (1 + r);
  }

  /// Sanchayapatra current value (simple interest, profit compounded per period)
  static double sanchayapatraCurrentValue({
    required double purchaseAmount,
    required double annualProfitRate,
    required DateTime purchaseDate,
  }) {
    final days = DateTime.now().difference(purchaseDate).inDays;
    if (days <= 0) return purchaseAmount;
    final profit = purchaseAmount * (annualProfitRate / 100) * (days / 365);
    return purchaseAmount + profit;
  }

  /// Sanchayapatra maturity value
  static double sanchayapatraMaturityValue({
    required double purchaseAmount,
    required double annualProfitRate,
    required DateTime purchaseDate,
    required DateTime maturityDate,
  }) {
    final days = maturityDate.difference(purchaseDate).inDays;
    final profit = purchaseAmount * (annualProfitRate / 100) * (days / 365);
    return purchaseAmount + profit;
  }

  /// Investment ROI %
  static double investmentROI({
    required double investedAmount,
    required double currentValue,
  }) {
    if (investedAmount == 0) return 0;
    return ((currentValue - investedAmount) / investedAmount) * 100;
  }

  /// Savings rate %
  static double savingsRate({
    required double income,
    required double expenses,
  }) {
    if (income == 0) return 0;
    final savings = income - expenses;
    return (savings / income) * 100;
  }

  /// Financial health score 0–100
  static double healthScore({
    required double savingsRatePercent,
    required double totalInvestments,
    required double totalSavingsInstruments,
    required double netWorth,
    required double monthlyExpenses,
  }) {
    double score = 0;

    // Savings rate (30 pts)
    if (savingsRatePercent >= 30) {
      score += 30;
    } else if (savingsRatePercent >= 20) {
      score += 22;
    } else if (savingsRatePercent >= 10) {
      score += 14;
    } else if (savingsRatePercent > 0) {
      score += 6;
    }

    // Investments (25 pts)
    if (totalInvestments > 0) score += 25;

    // DPS/FDR/Sanchayapatra (20 pts)
    if (totalSavingsInstruments > 0) score += 20;

    // Net worth positive (15 pts)
    if (netWorth > monthlyExpenses * 6) {
      score += 15; // 6-month emergency buffer
    } else if (netWorth > 0) {
      score += 8;
    }

    // Positive budget (10 pts)
    if (netWorth > 0 && savingsRatePercent > 0) score += 10;

    return score.clamp(0, 100);
  }

  static String healthLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    if (score >= 20) return 'Needs Work';
    return 'Poor';
  }

  static int _monthsElapsed(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }
}
