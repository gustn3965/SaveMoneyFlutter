class DaySpendListAction {
  void Function(int spendId) didClickModifySpendItem;

  DaySpendListAction(this.didClickModifySpendItem);
}

class DaySpendListViewModelItem {
  String categoryName;
  DateTime date;
  int spendMoney;
  int identity;

  DaySpendListViewModelItem(
      this.categoryName, this.date, this.spendMoney, this.identity);
}

abstract class DaySpendListViewModel {
  DaySpendListAction action;

  List<DaySpendListViewModelItem> spendList = [];
  late DateTime date;
  late int groupId;
  int totalSpendMoney = 0;

  DaySpendListViewModel(this.action, this.date, this.groupId);

  void didClickModifySpendItem(int index);
  void reloadFetch();

  // Observing
  Stream<DaySpendListViewModel> get dataStream;
  void dispose();
}
