

class EditGroupMonthMoneyAction {
  void Function() didEditGroupMonth;
  void Function() didCancelEdit;

  EditGroupMonthMoneyAction(this.didEditGroupMonth, this.didCancelEdit);
}

abstract class EditGroupMonthMoneyViewModel {
  late EditGroupMonthMoneyAction actions;
  late int plannedBudget;
  late int everyExpectedMoney;
  late bool availableConfirmButton;
  late DateTime date;

  EditGroupMonthMoneyViewModel(String groupMonthId);

  void didChangePlannedBudget(int plannedBudget);
  void didChangeEveryExpectedMoney(int everyExpectedMoney);
  void didClickConfirmButton();
  void didClickCancelButton();

  // Observing
  Stream<EditGroupMonthMoneyViewModel> get dataStream;
  void dispose();
}
