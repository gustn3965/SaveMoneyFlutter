import 'package:flutter/material.dart';

import '../../../../Domain/Entity/Spend.dart';

class GroupMonthCalendarActions {
  final void Function(DateTime date) updateDateTime;
  final void Function(DateTime date) updateSelectedDateTime;

  GroupMonthCalendarActions(this.updateDateTime, this.updateSelectedDateTime);
}

abstract class GroupMonthCalendarViewModel {
  Map<DateTime, List<Spend>> spendList = {};
  late GroupMonthCalendarActions groupMonthCalendarActions;
  late DateTime focuseDate;
  late DateTime? selectedDate;
  late int plannedBudgeEveryDay;

  Future<void> didSelectDate(DateTime date);
  Future<void> didChangeMonth(DateTime date);

  Future<void> fetchGroupMonths(List<String> groupMonthIds);
  Future<void> fetchGroupMonthWithSpendCategories(
      List<String> spendCategoryIds);
  void reloadFetch();

  // Observing
  Stream<GroupMonthCalendarViewModel> get dataStream;
  void dispose();
}
