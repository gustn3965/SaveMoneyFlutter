import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../../Extension/DateTime+Extension.dart';
import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthSummaryViewModel.dart';

class DefaultGroupMonthSummaryViewModel extends GroupMonthSummaryViewModel {
  late String monthGroupTitle = "";
  late int monthGroupWillSaveMoney = 0;
  late Color monthGroupWillSaveMoneyTextColor = Colors.blueAccent;
  late String moneyDescription = "";
  late int monthGroupPlannedBudget = 0;
  late int monthGroupPlannedBudgetByEveryday = 0;
  late int monthTotalSpendMoney = 0;

  final _dataController =
      StreamController<GroupMonthSummaryViewModel>.broadcast();
  Stream<GroupMonthSummaryViewModel> get dataStream => _dataController.stream;
  List<String> groupMonthIds = [];

  final GroupMonthFetchUseCase groupMonthFetchUseCase;
  DefaultGroupMonthSummaryViewModel(this.groupMonthFetchUseCase);

  @override
  Future<void> fetchGroupMonths(List<String> groupsIds) async {
    groupMonthIds = groupsIds;

    List<GroupMonth> groupMonths =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupIds(groupsIds);

    resetProperties();
    for (int index = 0; index < groupMonths.length; index ++) {
      GroupMonth groupMonth = groupMonths[index];
      monthGroupTitle = '${monthGroupTitle}${groupMonth.groupCategory.name}';
      if (index + 1 < groupMonths.length) {
        monthGroupTitle = '${monthGroupTitle}, ';
      }
      monthGroupWillSaveMoney += makeWillSaveMoney(groupMonth);
      monthGroupPlannedBudget += groupMonth?.plannedBudget ?? 0;
      monthGroupPlannedBudgetByEveryday +=
          groupMonth?.plannedBudgetEveryday() ?? 0;
      monthTotalSpendMoney += makeAllSpendMoney(groupMonth, []);
    }
    monthGroupWillSaveMoneyTextColor =
        monthGroupWillSaveMoney >= 0 ? Colors.blueAccent : Colors.redAccent;
    moneyDescription =
        monthGroupWillSaveMoney >= 0 ? "돈을 모을 예정이에요.👍" : "돈이 나갈 예정이에요😢";

    _dataController.add(this);
  }

  @override
  Future<void> fetchGroupMonthWithSpendCategories(
      List<String> filterSpendCategory) async {
    List<GroupMonth> groupMonths =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupIds(groupMonthIds);

    resetProperties();

    for (GroupMonth groupMonth in groupMonths) {
      monthGroupTitle = '${monthGroupTitle}${groupMonth.groupCategory.name}, ';
      monthGroupWillSaveMoney += makeWillSaveMoney(groupMonth);
      monthGroupPlannedBudget += groupMonth?.plannedBudget ?? 0;
      monthGroupPlannedBudgetByEveryday +=
          groupMonth?.plannedBudgetEveryday() ?? 0;
      monthTotalSpendMoney +=
          makeAllSpendMoney(groupMonth, filterSpendCategory);
    }
    monthGroupWillSaveMoneyTextColor =
        monthGroupWillSaveMoney > 0 ? Colors.blueAccent : Colors.redAccent;
    moneyDescription =
        monthGroupWillSaveMoney > 0 ? "돈을 모을 예정이에요.👍" : "돈이 나갈 예정이에요ㅠ";

    // 업데이트된 데이터를 StreamController를 통해 스트림으로 전달
    _dataController.add(this);
  }

  void resetProperties() {
    monthGroupTitle = "";
    monthGroupWillSaveMoney = 0;
    monthGroupPlannedBudget = 0;
    monthGroupPlannedBudgetByEveryday = 0;
    monthTotalSpendMoney = 0;
    monthGroupWillSaveMoneyTextColor = Colors.black;
    moneyDescription = "";
  }

  int makeWillSaveMoney(GroupMonth? groupMonth) {
    Map<DateTime, int> map = {};

    int everyDayWillSpend = groupMonth?.plannedBudgetEveryday() ?? 0;

    for (Spend spend in groupMonth?.spendList ?? []) {
      DateTime dateKey = dateTimeAfterMonthDay(spend.date, 0, 0);

      int spendMoney = (-spend.spendMoney);
      if (spend.spendType == SpendType.nonSpend) {
        spendMoney = 0;
      }

      if (map[dateKey] == null) {
        map[dateKey] = spendMoney + everyDayWillSpend;
      } else {
        map[dateKey] = (map[dateKey] ?? 0) + spendMoney;
      }
    }

    int willSaveMoney =
        map.values.fold(0, (previousValue, element) => previousValue + element);

    return willSaveMoney;
  }

  int makeAllSpendMoney(
      GroupMonth? groupMonth, List<String> filterSpendCategory) {
    int totalSpendMoney = 0;
    for (Spend spend in groupMonth?.spendList ?? []) {
      if (filterSpendCategory.isNotEmpty &&
          filterSpendCategory.contains(spend.spendCategory?.identity ?? "") ==
              false) {
        continue;
      }

      totalSpendMoney += spend.spendMoney;
    }
    return totalSpendMoney;
  }

  @override
  void reloadFetch() {
    // fetchGroupMonth(groupMonthIdentity);
    fetchGroupMonths(groupMonthIds);
  }

  void dispose() {
    _dataController.close();
  }
}
