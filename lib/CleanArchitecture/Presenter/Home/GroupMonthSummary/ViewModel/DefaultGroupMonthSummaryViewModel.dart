import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../../Extension/DateTime+Extension.dart';
import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthSummaryViewModel.dart';

class DefaultGroupMonthSummaryViewModel extends GroupMonthSummaryViewModel {
  late String? monthGroupTitle = null;
  late int monthGroupWillSaveMoney;
  late Color monthGroupWillSaveMoneyTextColor;
  late String moneyDescription;
  late int monthGroupPlannedBudget;
  late int monthGroupPlannedBudgetByEveryday;

  final _dataController =
      StreamController<GroupMonthSummaryViewModel>.broadcast();
  Stream<GroupMonthSummaryViewModel> get dataStream => _dataController.stream;
  String? groupMonthIdentity;

  final GroupMonthFetchUseCase groupMonthFetchUseCase;
  DefaultGroupMonthSummaryViewModel(this.groupMonthFetchUseCase);

  @override
  Future<void> fetchGroupMonth(String? identity) async {
    groupMonthIdentity = identity;
    if (identity == null) {
      _dataController.addError(Error());
      return;
    }

    GroupMonth? groupMonth =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupId(identity);

    monthGroupTitle = groupMonth?.groupCategory.name ?? '';
    monthGroupWillSaveMoney = makeWillSaveMoney(groupMonth);
    monthGroupWillSaveMoneyTextColor = Colors.blueAccent;
    moneyDescription = "돈을 모을 예정이에요.👍";
    monthGroupPlannedBudget = groupMonth?.plannedBudget ?? 0;
    monthGroupPlannedBudgetByEveryday =
        groupMonth?.plannedBudgetEveryday() ?? 0;

    // 업데이트된 데이터를 StreamController를 통해 스트림으로 전달
    _dataController.add(this);
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

  @override
  void reloadFetch() {
    fetchGroupMonth(groupMonthIdentity);
  }

  void dispose() {
    _dataController.close();
  }
}
