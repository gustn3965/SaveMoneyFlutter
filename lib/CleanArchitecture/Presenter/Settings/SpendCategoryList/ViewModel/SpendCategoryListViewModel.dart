class SpendCategoryListAction {
  void Function(String spendCategoryId) showEditSpendCategoryWidget;
  void Function() showAddSpendCategoryWidget;
  void Function() navigationPop;

  SpendCategoryListAction(
      {required this.showEditSpendCategoryWidget,
      required this.showAddSpendCategoryWidget,
      required this.navigationPop});
}

class SpendCategoryListItem {
  String name;
  String categoryId;
  String editStringName;

  SpendCategoryListItem(this.name, this.categoryId, this.editStringName);
}

abstract class SpendCategoryListViewModel {
  late SpendCategoryListAction action;

  late List<SpendCategoryListItem> items;

  final String addSpendCategoryString = "추가하기";

  void didClickNavigationPopButton();

  void clickEditSpendCategoryItem(SpendCategoryListItem item);

  void clickAddSpendCategory();

  void reloadData();

  // Observing
  Stream<SpendCategoryListViewModel> get dataStream;

  void dispose();
}
