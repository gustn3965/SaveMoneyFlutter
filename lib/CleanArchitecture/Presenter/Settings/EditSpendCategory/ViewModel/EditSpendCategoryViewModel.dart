class EditSpendCategoryActions {
  void Function() doneSaveEdit;
  void Function() doneDeleteSpendCategory;
  void Function() showAlertWarningEdit;
  void Function() showAlertSameName;
  void Function() showAlertWarningDelete;

  EditSpendCategoryActions(
      {required this.doneSaveEdit,
      required this.doneDeleteSpendCategory,
      required this.showAlertWarningEdit,
      required this.showAlertSameName,
      required this.showAlertWarningDelete});
}

class EditSpendCategoryItem {
  late String groupName;
  late String description;
  late String date;
  late int spendMoney;

  EditSpendCategoryItem(
      {required this.groupName,
      required this.description,
      required this.date,
      required this.spendMoney});
}

abstract class EditSpendCategoryViewModel {
  late EditSpendCategoryActions actions;

  late bool availableEditButton;
  late bool availableDeleteButton;
  late String spendCategoryName;
  late int maxNameLength;

  late List<EditSpendCategoryItem> spendListItem;

  void didChangeSpendCategoryName(String categoryName);

  void didClickEditButton();

  void didClickDeleteButton();

  void doUpdateSpendCategory();

  void doDeleteSpendCategory();

  // Observing
  Stream<EditSpendCategoryViewModel> get dataStream;

  void dispose();
}
