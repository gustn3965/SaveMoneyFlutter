import 'dart:ui';

abstract class GroupMonthSummaryViewModel {
  late String? monthGroupTitle;
  late int monthGroupWillSaveMoney; // 돈을 모을예정
  late Color monthGroupWillSaveMoneyTextColor; // 돈을 모을예정
  late String moneyDescription;
  late int monthGroupPlannedBudget; // 설정한 금액
  late int monthGroupPlannedBudgetByEveryday;
  late int monthTotalSpendMoney; // 총 소비한 금액

  Future<void> fetchGroupMonth(String? identity);
  Future<void> fetchGroupMonthWithSpendCategories(
      List<String> filterSpendCategory);
  void reloadFetch();

  // Observing
  Stream<GroupMonthSummaryViewModel> get dataStream;
  void dispose();
}
