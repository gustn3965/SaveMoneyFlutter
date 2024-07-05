class DaySpendListAction {
  void Function(String spendId) didClickModifySpendItem;

  DaySpendListAction(this.didClickModifySpendItem);
}

class DaySpendListViewModelItem {
  String categoryName;
  DateTime date;
  int spendMoney;
  String identity;
  String description;

  DaySpendListViewModelItem(
      {required this.categoryName,
      required this.date,
      required this.spendMoney,
      required this.identity,
      required this.description});
}

abstract class DaySpendListViewModel {
  DaySpendListAction action;

  List<DaySpendListViewModelItem> spendList = [];
  late DateTime date;
  late List<String> groupIds;
  late List<String> spendCategories = [];

  int totalSpendMoney = 0;

  DaySpendListViewModel(this.action, this.date, this.groupIds);

  void didClickModifySpendItem(int index);
  void reloadFetch();

  // Observing
  Stream<DaySpendListViewModel> get dataStream;
  void dispose();
}
