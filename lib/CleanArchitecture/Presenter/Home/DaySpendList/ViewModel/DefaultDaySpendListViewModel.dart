import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/UseCase/DaySpendListUseCase.dart';

import '../../../../Domain/Entity/Spend.dart';
import 'DaySpendListViewModel.dart';

class DefaultDaySpendListViewModel extends DaySpendListViewModel {
  DaySpendListUseCase daySpendListUseCase;

  final _dataController = StreamController<DaySpendListViewModel>.broadcast();
  @override
  Stream<DaySpendListViewModel> get dataStream => _dataController.stream;

  DefaultDaySpendListViewModel(
      super.action, super.date, super.groupIds, this.daySpendListUseCase) {
    fetchDaySpendList(groupIds, date, spendCategories);
  }

  @override
  void didClickModifySpendItem(int index) {
    action.didClickModifySpendItem(spendList[index].identity);
  }

  @override
  void reloadFetch() {
    fetchDaySpendList(groupIds, date, spendCategories);
  }

  @override
  Future<void> fetchDaySpendList(List<String> groupIds, DateTime date,
      List<String> filterSpendCategories) async {
    List<Spend> list =
        await daySpendListUseCase.fetchDaySpendLists(groupIds, date);

    this.date = date;
    spendList = convertItems(list, filterSpendCategories);
    totalSpendMoney = makeTotalSpendMoney(list);

    _dataController.add(this);
  }

  List<DaySpendListViewModelItem> convertItems(
      List<Spend> spendList, List<String> filterSpendcategories) {
    List<DaySpendListViewModelItem> list = [];
    for (Spend spend in spendList) {
      if (spend.spendType == SpendType.nonSpend) {
        continue;
      }

      if (filterSpendcategories.isNotEmpty &&
          filterSpendcategories.contains(spend.spendCategory?.identity ?? "") ==
              false) {
        continue;
      }

      list.add(DaySpendListViewModelItem(spend.spendCategory?.name ?? "",
          spend.date, spend.spendMoney, spend.identity));
    }
    return list;
  }

  int makeTotalSpendMoney(List<Spend> spendList) {
    int totalMoney = 0;
    for (Spend spend in spendList) {
      totalMoney += spend.spendMoney;
    }

    return totalMoney;
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
