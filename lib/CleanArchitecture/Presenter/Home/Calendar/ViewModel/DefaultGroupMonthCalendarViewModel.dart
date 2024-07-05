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
  List<String> groupMonthIds = [];

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
    this.selectedDate = date;
    this.focuseDate = date;
    this.groupMonthCalendarActions.updateDateTime(date);
  }

  @override
  Future<void> fetchGroupMonths(List<String> groupMonthIds) async {
    this.groupMonthIds = groupMonthIds;
    List<GroupMonth> groupMonths =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupIds(groupMonthIds);

    spendList = convertGroupMonthToMap(groupMonths, []);
    plannedBudgeEveryDay = groupMonths.fold(
        0,
        (previousValue, element) =>
            previousValue + element.plannedBudgetEveryday());

    if (groupMonths.isNotEmpty) {
      this.focuseDate = groupMonths.first!.date;
    } else {
      this.focuseDate = this.focuseDate;
    }

    _dataController.add(this);
  }

  Future<void> fetchGroupMonthWithSpendCategories(
      List<String> spendCategoryIds) async {
    List<GroupMonth> groupMonths =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupIds(groupMonthIds);

    spendList = convertGroupMonthToMap(groupMonths, spendCategoryIds);
    plannedBudgeEveryDay = groupMonths.fold(
        0,
        (previousValue, element) =>
            previousValue + element.plannedBudgetEveryday());

    this.focuseDate = groupMonths.first?.date ?? this.focuseDate;
    _dataController.add(this);
  }

  @override
  void reloadFetch() {
    fetchGroupMonths(groupMonthIds);
  }

  Map<DateTime, List<Spend>> convertGroupMonthToMap(
      List<GroupMonth> groupMonths, List<String> spendCategoryList) {
    Map<DateTime, List<Spend>> map = {};

    for (GroupMonth group in groupMonths) {
      for (Spend spend in group.spendList) {
        if (spendCategoryList.isNotEmpty &&
            spendCategoryList.contains(spend.spendCategory?.identity) ==
                false) {
          continue;
        }

        DateTime dateKey = dateTimeAfterMonthDay(spend.date, 0, 0);
        if (map[dateKey] == null) {
          map[dateKey] = [spend];
        } else {
          map[dateKey]?.add(spend);
        }
      }
    }

    return map;
  }

  void dispose() {
    _dataController.close();
  }
}
