
class SearchSpendAction {
  void Function(String spendId) didClickEditSpend;

  SearchSpendAction({required this.didClickEditSpend});
}

class SearchSpendItem {

}
class SearchSpendItemDate extends SearchSpendItem {
  String dateString;
  DateTime date;
  SearchSpendItemDate({required this.dateString, required this.date});
}
class SearchSpendItemSpend extends SearchSpendItem {
  String spendIdentity;
  String groupCategoryName;
  String spendCategoryName;
  String description;
  String spendMoneyString;
  String dateString;

  SearchSpendItemSpend({required this.spendIdentity, required this.groupCategoryName, required this.spendCategoryName, required this.description, required this.spendMoneyString, required this.dateString});
}

abstract class SearchSpendViewModel {
  SearchSpendAction action;

  String searchName = "";

  List<SearchSpendItem> items = [];

  int maxNameLength = 60;

  SearchSpendViewModel({required this.action});

  void didChangeSearchName(String searchName);
  void didClickSearchButton();
  void didClickEditSpendItem(SearchSpendItemSpend item);

  void reloadData();
  // Observing
  Stream<SearchSpendViewModel> get dataStream;
  void dispose();
}