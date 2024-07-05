
class MonthSpendListAction {
  void Function(String spendId) didClickModifySpendItem;

  MonthSpendListAction(this.didClickModifySpendItem);
}

class MonthSpendListItem {

}

class MonthSpendListItemDate extends MonthSpendListItem {
  DateTime date;
  MonthSpendListItemDate({required this.date});
}

class MonthSpendListItemSpend extends MonthSpendListItem {
  String categoryName;
  DateTime date;
  int spendMoney;
  String identity;
  String description;

  MonthSpendListItemSpend(
      {required this.categoryName,
        required this.date,
        required this.spendMoney,
        required this.identity,
        required this.description});
}

abstract class MonthSpendListViewModel {
  MonthSpendListAction action;

  List<MonthSpendListItem> spendList = [];
  late List<String> groupIds;
  late List<String> spendCategories = [];

  int totalSpendMoney = 0;

  MonthSpendListViewModel(this.action, this.groupIds);

  void didClickModifySpendItem(int index);
  void reloadFetch();
  int onlyItemListCount();

  // Observing
  Stream<MonthSpendListViewModel> get dataStream;
  void dispose();

}