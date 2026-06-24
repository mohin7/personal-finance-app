import 'package:hugeicons/hugeicons.dart';

class AppIcons {
  AppIcons._();

  // ── Bottom nav ──────────────────────────────────────────────────────
  static const dashboard  = HugeIcons.strokeRoundedHome01;
  static const expenses   = HugeIcons.strokeRoundedMoneySend02;
  static const income     = HugeIcons.strokeRoundedMoneyReceive02;
  static const investments = HugeIcons.strokeRoundedChartLineData01;
  static const more       = HugeIcons.strokeRoundedGridView;

  // ── Finance ─────────────────────────────────────────────────────────
  static const wallet          = HugeIcons.strokeRoundedWallet01;
  static const cash            = HugeIcons.strokeRoundedCash01;
  static const bank            = HugeIcons.strokeRoundedBank;
  static const dps             = HugeIcons.strokeRoundedPiggyBank;
  static const fdr             = HugeIcons.strokeRoundedLockPassword;
  static const sanchayapatra   = HugeIcons.strokeRoundedFile01;
  static const budget          = HugeIcons.strokeRoundedPieChart;
  static const reports         = HugeIcons.strokeRoundedBarChart;
  static const settings        = HugeIcons.strokeRoundedSettings01;
  static const netWorth        = HugeIcons.strokeRoundedAnalyticsUp;

  // ── Actions ─────────────────────────────────────────────────────────
  static const loan         = HugeIcons.strokeRoundedAgreement01;
  static const add          = HugeIcons.strokeRoundedAddCircle;
  static const edit         = HugeIcons.strokeRoundedPencilEdit01;
  static const delete       = HugeIcons.strokeRoundedDelete01;
  static const search       = HugeIcons.strokeRoundedSearch01;
  static const filter       = HugeIcons.strokeRoundedFilter;
  static const close        = HugeIcons.strokeRoundedCancel01;
  static const check        = HugeIcons.strokeRoundedCheckmarkCircle01;
  static const calendar     = HugeIcons.strokeRoundedCalendar01;
  static const notification = HugeIcons.strokeRoundedNotification01;
  static const share        = HugeIcons.strokeRoundedShare01;
  static const download     = HugeIcons.strokeRoundedDownload01;
  static const back         = HugeIcons.strokeRoundedArrowLeft01;

  // ── Status / Security ───────────────────────────────────────────────
  static const lock      = HugeIcons.strokeRoundedLockPassword;
  static const biometric = HugeIcons.strokeRoundedFingerPrint;
  static const profit    = HugeIcons.strokeRoundedAnalyticsUp;
  static const loss      = HugeIcons.strokeRoundedAnalyticsDown;

  // ── Category icons ───────────────────────────────────────────────────
  static const categoryFood          = HugeIcons.strokeRoundedRestaurant01;
  static const categoryTransport     = HugeIcons.strokeRoundedCar01;
  static const categoryRent          = HugeIcons.strokeRoundedHome01;
  static const categoryUtilities     = HugeIcons.strokeRoundedFlash;
  static const categoryShopping      = HugeIcons.strokeRoundedShoppingBag01;
  static const categoryMobile        = HugeIcons.strokeRoundedPhoneLock;
  static const categoryInternet      = HugeIcons.strokeRoundedWifi01;
  static const categoryMedical       = HugeIcons.strokeRoundedHospital01;
  static const categoryEducation     = HugeIcons.strokeRoundedBookOpen01;
  static const categoryFamily        = HugeIcons.strokeRoundedGroup;
  static const categoryEntertainment = HugeIcons.strokeRoundedGameController01;
  static const categoryTravel        = HugeIcons.strokeRoundedAirplane01;
  static const categoryOther         = HugeIcons.strokeRoundedMoreHorizontal;

  static List<List<dynamic>> categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':          return categoryFood;
      case 'transport':     return categoryTransport;
      case 'rent':          return categoryRent;
      case 'utilities':     return categoryUtilities;
      case 'shopping':      return categoryShopping;
      case 'mobile recharge': return categoryMobile;
      case 'internet':      return categoryInternet;
      case 'medical':       return categoryMedical;
      case 'education':     return categoryEducation;
      case 'family':        return categoryFamily;
      case 'entertainment': return categoryEntertainment;
      case 'travel':        return categoryTravel;
      default:              return categoryOther;
    }
  }
}
