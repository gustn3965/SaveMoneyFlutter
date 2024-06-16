class EditGroupCategoryActions {
  void Function() doneSaveEdit;
  void Function() doneDeleteGroupCategory;
  void Function() showAlertWarningEdit;
  void Function() showAlertWarningDelete;

  EditGroupCategoryActions(
      {required this.doneSaveEdit,
      required this.doneDeleteGroupCategory,
      required this.showAlertWarningEdit,
      required this.showAlertWarningDelete});
}

class EditGroupCategoryItem {
  late String groupName;
  late String totalSpendMoneyString;
  late String date;
  late String plannedbudgetString;
  late int totalSpendMoney;
  late int plannedbudget;

  EditGroupCategoryItem(
      {required this.groupName,
      required this.totalSpendMoneyString,
      required this.date,
      required this.plannedbudgetString,
      required this.totalSpendMoney,
      required this.plannedbudget});
}

abstract class EditGroupCategoryViewModel {
  late EditGroupCategoryActions actions;

  late bool availableEditButton;
  late String groupCategoryName;

  late List<EditGroupCategoryItem> groupListItem;

  void didChangeGroupCategoryName(String categoryName);
  void didClickEditButton();
  void didClickDeleteButton();
  void doUpdateGroupCategory();
  void doDeleteSpendCategory();
  // Observing
  Stream<EditGroupCategoryViewModel> get dataStream;
  void dispose();
}
