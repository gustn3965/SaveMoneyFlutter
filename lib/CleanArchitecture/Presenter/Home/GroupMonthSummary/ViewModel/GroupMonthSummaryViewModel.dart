import 'dart:ui';

abstract class GroupMonthSummaryViewModel {
  late String? monthGroupTitle;
  late int monthGroupWillSaveMoney; // 돈을 모을예정
  late Color monthGroupWillSaveMoneyTextColor; // 돈을 모을예정
  late String moneyDescription;
  late int monthGroupPlannedBudget; // 설정한 금액
  late int monthGroupPlannedBudgetByEveryday;

  Future<void> fetchGroupMonth(String? identity);
  void reloadFetch();

  // Observing
  Stream<GroupMonthSummaryViewModel> get dataStream;
  void dispose();
}
