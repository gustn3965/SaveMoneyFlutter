class AddSpendCategoryActions {
  void Function() didAddSpendCategory;
  void Function() didClickCancel;
  void Function() showAlertHasAlreadySameNameCategory;

  AddSpendCategoryActions(this.didAddSpendCategory, this.didClickCancel,
      this.showAlertHasAlreadySameNameCategory);
}

abstract class AddSpendCategoryViewModel {
  late AddSpendCategoryActions actions;
  late bool availableConfirmButton;

  late String spendCategoryName;
  late int maxNameLength;

  void didChangeSpendCategoryName(String categoryName);
  void didClickConfirmButton();
  void didClickCancelButton();
  void reloadData();
  // Observing
  Stream<AddSpendCategoryViewModel> get dataStream;
  void dispose();
}
