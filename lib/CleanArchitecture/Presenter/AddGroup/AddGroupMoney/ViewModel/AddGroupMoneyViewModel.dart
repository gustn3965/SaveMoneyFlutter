class AddGroupMoneyAction {
  void Function() didAddNewGroup;
  void Function() cancelAddGroupMoney;

  AddGroupMoneyAction(this.didAddNewGroup, this.cancelAddGroupMoney);
}

abstract class AddGroupMoneyViewModel {
  late AddGroupMoneyAction actions;
  late int plannedBudget;
  late int everyExpectedMoney;
  late bool availableConfirmButton;
  late DateTime date;

  AddGroupMoneyViewModel(DateTime date, String groupName);

  void didChangePlannedBudget(int plannedBudget);
  void didChangeEveryExpectedMoney(int everyExpectedMoney);
  void didClickConfirmButton();
  void didClickCancelButton();
  void reloadData();
  // Observing
  Stream<AddGroupMoneyViewModel> get dataStream;
  void dispose();
}
