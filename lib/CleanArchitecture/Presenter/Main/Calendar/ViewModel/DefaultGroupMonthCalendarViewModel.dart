import 'dart:async';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthCalendarViewModel.dart';

class DefaultGroupMonthCalendarViewModel extends GroupMonthCalendarViewModel {
  Map<DateTime, List<Spend>> spendList = {};

  final GroupMonthFetchUseCase groupMonthFetchUseCase;

  late GroupMonthCalendarActions groupMonthCalendarActions;

  late DateTime focuseDate = DateTime.now();
  late DateTime? selectedDate = null;

  final _dataController = StreamController<GroupMonthCalendarViewModel>();
  Stream<GroupMonthCalendarViewModel> get dataStream => _dataController.stream;

  DefaultGroupMonthCalendarViewModel(
      this.groupMonthFetchUseCase, this.groupMonthCalendarActions);

  Future<void> didSelectDate(DateTime date) async {
    this.selectedDate = date;
    this.groupMonthCalendarActions.updateSelectedDateTime(date);
    _dataController.add(this);
  }

  Future<void> didChangeMonth(DateTime date) async {
    this.focuseDate = date;
    this.groupMonthCalendarActions.updateDateTime(date);
  }

  Future<void> fetchGroupMonth(int? groupMonthId) async {
    GroupMonth? groupMonth =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupId(groupMonthId);

    spendList = convertGroupMonthToMap(groupMonth);

    this.focuseDate = groupMonth?.date ?? this.focuseDate;
    _dataController.add(this);
  }

  Map<DateTime, List<Spend>> convertGroupMonthToMap(GroupMonth? groupMonth) {
    Map<DateTime, List<Spend>> map = {};

    for (var spend in groupMonth?.spendList ?? []) {
      if (map[spend.date] == null) {
        map[spend.date] = [spend];
      } else {
        map[spend.date]?.add(spend);
      }
    }
    return map;
  }

  void dispose() {
    _dataController.close();
  }
}
