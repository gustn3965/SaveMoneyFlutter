import 'dart:ui';

abstract class GroupMonthSummaryViewModel {
  late String monthGroupTitle;
  late int monthGroupWillSaveMoney;
  late Color monthGroupWillSaveMoneyTextColor;
  late String moneyDescription;
  late int monthGroupPlannedBudget;
  late int monthGroupPlannedBudgetByEveryday;

  Future<void> fetchGroupMonth(int? identity);
  void reloadFetch();

  // Observing
  Stream<GroupMonthSummaryViewModel> get dataStream;
  void dispose();
}
