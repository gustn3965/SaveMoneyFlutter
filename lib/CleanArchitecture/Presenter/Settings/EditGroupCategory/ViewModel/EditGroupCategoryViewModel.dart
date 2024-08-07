class EditGroupCategoryActions {
  void Function() doneSaveEdit;
  void Function() doneDeleteGroupCategory;
  void Function() showAlertWarningEdit;
  void Function() showAlertWarningDelete;
  void Function() navigationPop;
  void Function(String groupMonthid) showEditGroupMonthMoney;

  EditGroupCategoryActions(
      {required this.doneSaveEdit,
      required this.doneDeleteGroupCategory,
      required this.showAlertWarningEdit,
      required this.showAlertWarningDelete,
      required this.showEditGroupMonthMoney,
      required this.navigationPop});
}

class EditGroupCategoryItem {
  late String groupName;
  late String totalSpendMoneyString;
  late String date;
  late String plannedbudgetString;
  late int totalSpendMoney;
  late int plannedbudget;
  late String editMoneyButtonString;
  late String groupMonthId;

  EditGroupCategoryItem(
      {required this.groupName,
      required this.totalSpendMoneyString,
      required this.date,
      required this.plannedbudgetString,
      required this.totalSpendMoney,
      required this.plannedbudget,
      required this.editMoneyButtonString,
      required this.groupMonthId});
}

abstract class EditGroupCategoryViewModel {
  late EditGroupCategoryActions actions;

  late bool availableEditButton;
  late bool availableDeleteButton;
  late String groupCategoryName;
  late int maxNameLength;

  late List<EditGroupCategoryItem> groupListItem;

  void didClickNavigationPopButton();

  void didChangeGroupCategoryName(String categoryName);

  void didClickEditButton();

  void didClickDeleteButton();

  void didClickItemEditGroupMoney(EditGroupCategoryItem item);

  void doUpdateGroupCategory();

  void doDeleteSpendCategory();

  void reloadData();

  // Observing
  Stream<EditGroupCategoryViewModel> get dataStream;

  void dispose();
}
