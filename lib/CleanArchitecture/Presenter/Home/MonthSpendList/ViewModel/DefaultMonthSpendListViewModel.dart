import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/MonthSpendList/ViewModel/MonthSpendListViewModel.dart';

import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/SpendListUseCase.dart';

class DefaultMonthSpendListViewModel extends MonthSpendListViewModel {
  SpendListUseCase groupSpendListUseCase;

  @override
  late List<String> groupIds = [];
  @override
  late List<String> spendCategories = [];

  DefaultMonthSpendListViewModel(
      super.action, super.groupIds, this.groupSpendListUseCase) {
    fetchDaySpendList(groupIds, spendCategories);
  }

  @override
  void didClickModifySpendItem(int index) {
    MonthSpendListItem item = spendList[index];
    if (item is MonthSpendListItemSpend) {
      MonthSpendListItemSpend itemSpend = item;
      action.didClickModifySpendItem(itemSpend.identity);
    }
  }

  @override
  int onlyItemListCount() {
    return spendList.where((item) => item is MonthSpendListItemSpend).length;
  }

  @override
  void reloadFetch() {
    fetchDaySpendList(groupIds, spendCategories);
  }

  Future<void> fetchDaySpendList(
      List<String> selectedGroupIds, List<String> filterSpendCategories) async {
    List<Spend> list = await groupSpendListUseCase.fetchSpendListGroupIds(
        spendCategoryIds: filterSpendCategories,
        groupIds: selectedGroupIds,
        descending: true);

    spendList = convertItems(list);
    totalSpendMoney = makeTotalSpendMoney(list);

    _dataController.add(this);
  }

  List<MonthSpendListItem> convertItems(List<Spend> spendList) {
    List<MonthSpendListItem> items = [];

    Set<DateTime> dateSet = {};

    for (Spend spend in spendList) {
      DateTime date =
          DateTime(spend.date.year, spend.date.month, spend.date.day);

      MonthSpendListItemSpend spendItem = MonthSpendListItemSpend(
          categoryName: spend.spendCategory?.name ?? "",
          date: spend.date,
          spendMoney: spend.spendMoney,
          identity: spend.identity,
          description: spend.description);
      if (dateSet.contains(date)) {
        items.add(spendItem);
      } else {
        dateSet.add(date);
        items.add(MonthSpendListItemDate(date: date));
        items.add(spendItem);
      }
    }

    return items;
  }

  int makeTotalSpendMoney(List<Spend> spendList) {
    int totalMoney = 0;
    for (Spend spend in spendList) {
      if (spend.spendType == SpendType.realSpend) {
        totalMoney += spend.spendMoney;
      }
    }

    return totalMoney;
  }

  // Observing
  final _dataController = StreamController<MonthSpendListViewModel>.broadcast();

  @override
  Stream<MonthSpendListViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
