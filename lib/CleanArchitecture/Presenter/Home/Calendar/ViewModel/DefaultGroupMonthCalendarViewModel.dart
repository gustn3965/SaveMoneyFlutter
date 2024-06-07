import 'dart:async';

import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthCalendarViewModel.dart';

class DefaultGroupMonthCalendarViewModel extends GroupMonthCalendarViewModel {
  Map<DateTime, List<Spend>> spendList = {};
  late GroupMonthCalendarActions groupMonthCalendarActions;
  late DateTime focuseDate = DateTime.now();
  late DateTime? selectedDate = null;
  late int plannedBudgeEveryDay = 0;
  String? groupMonthIdentity;

  final _dataController =
      StreamController<GroupMonthCalendarViewModel>.broadcast();
  Stream<GroupMonthCalendarViewModel> get dataStream => _dataController.stream;
  final GroupMonthFetchUseCase groupMonthFetchUseCase;

  DefaultGroupMonthCalendarViewModel(
      this.groupMonthFetchUseCase, this.groupMonthCalendarActions);

  @override
  Future<void> didSelectDate(DateTime date) async {
    this.selectedDate = date;
    this.groupMonthCalendarActions.updateSelectedDateTime(date);
    _dataController.add(this);
  }

  @override
  Future<void> didChangeMonth(DateTime date) async {
    this.focuseDate = date;
    this.groupMonthCalendarActions.updateDateTime(date);
  }

  @override
  Future<void> fetchGroupMonth(String? groupMonthId) async {
    groupMonthIdentity = groupMonthId;
    GroupMonth? groupMonth =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupId(groupMonthId);

    spendList = convertGroupMonthToMap(groupMonth, []);
    plannedBudgeEveryDay = groupMonth?.plannedBudgetEveryday() ?? 0;

    this.focuseDate = groupMonth?.date ?? this.focuseDate;
    _dataController.add(this);
  }

  Future<void> fetchGroupMonthWithSpendCategories(
      List<String> spendCategoryIds) async {
    GroupMonth? groupMonth = await groupMonthFetchUseCase
        .fetchGroupMonthByGroupId(groupMonthIdentity);

    spendList = convertGroupMonthToMap(groupMonth, spendCategoryIds);
    plannedBudgeEveryDay = groupMonth?.plannedBudgetEveryday() ?? 0;

    this.focuseDate = groupMonth?.date ?? this.focuseDate;
    _dataController.add(this);
  }

  @override
  void reloadFetch() {
    fetchGroupMonth(groupMonthIdentity);
  }

  Map<DateTime, List<Spend>> convertGroupMonthToMap(
      GroupMonth? groupMonth, List<String> spendCategoryList) {
    Map<DateTime, List<Spend>> map = {};

    for (Spend spend in groupMonth?.spendList ?? []) {
      if (spendCategoryList.isNotEmpty &&
          spendCategoryList.contains(spend.spendCategory?.identity) == false) {
        continue;
      }

      DateTime dateKey = dateTimeAfterMonthDay(spend.date, 0, 0);
      if (map[dateKey] == null) {
        map[dateKey] = [spend];
      } else {
        map[dateKey]?.add(spend);
      }
    }
    return map;
  }

  void dispose() {
    _dataController.close();
  }
}
