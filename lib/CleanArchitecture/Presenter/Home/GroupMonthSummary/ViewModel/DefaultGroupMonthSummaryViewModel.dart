import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../Domain/Entity/GroupMonth.dart';
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
  int? groupMonthIdentity;

  final GroupMonthFetchUseCase groupMonthFetchUseCase;
  DefaultGroupMonthSummaryViewModel(this.groupMonthFetchUseCase);

  @override
  Future<void> fetchGroupMonth(int? identity) async {
    groupMonthIdentity = identity;
    if (identity == null) {
      _dataController.addError(Error());
      return;
    }

    GroupMonth? groupMonth =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupId(identity);

    monthGroupTitle = groupMonth?.groupCategory.name ?? '';
    monthGroupWillSaveMoney = 500;
    monthGroupWillSaveMoneyTextColor = Colors.blueAccent;
    moneyDescription = "돈을 모을 예정이에요.👍";
    monthGroupPlannedBudget = groupMonth?.plannedBudget ?? 0;
    monthGroupPlannedBudgetByEveryday = 304;

    // 업데이트된 데이터를 StreamController를 통해 스트림으로 전달
    _dataController.add(this);
  }

  @override
  void reloadFetch() {
    fetchGroupMonth(groupMonthIdentity);
  }

  void dispose() {
    _dataController.close();
  }
}
