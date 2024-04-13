class LoginAddGroupMoneyAction {
  void Function() didAddNewGroup;
  void Function() cancelAddGroupMoney;

  LoginAddGroupMoneyAction(this.didAddNewGroup, this.cancelAddGroupMoney);
}

abstract class LoginAddGroupMoneyViewModel {
  late LoginAddGroupMoneyAction actions;
  late int plannedBudget;
  late int everyExpectedMoney;
  late bool availableConfirmButton;
  late DateTime date;

  LoginAddGroupMoneyViewModel(DateTime date, String groupName);

  void didChangePlannedBudget(int plannedBudget);
  void didChangeEveryExpectedMoney(int everyExpectedMoney);
  void didClickConfirmButton();
  void didClickCancelButton();

  // Observing
  Stream<LoginAddGroupMoneyViewModel> get dataStream;
  void dispose();
}
