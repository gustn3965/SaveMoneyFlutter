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
      super.action, super.date, super.groupId, this.daySpendListUseCase) {
    fetchDaySpendList(groupId, date);
  }

  @override
  void didClickModifySpendItem(int index) {
    action.didClickModifySpendItem(spendList[index].identity);
  }

  @override
  void reloadFetch() {
    fetchDaySpendList(groupId, date);
  }

  @override
  Future<void> fetchDaySpendList(String groupId, DateTime date) async {
    List<Spend> list =
        await daySpendListUseCase.fetchDaySpendList(groupId, date);

    this.date = date;
    spendList = convertItems(list);
    totalSpendMoney = makeTotalSpendMoney(list);

    _dataController.add(this);
  }

  List<DaySpendListViewModelItem> convertItems(List<Spend> spendList) {
    List<DaySpendListViewModelItem> list = [];
    for (Spend spend in spendList) {
      list.add(DaySpendListViewModelItem(spend.spendCategory.name, spend.date,
          spend.spendMoney, spend.identity));
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
