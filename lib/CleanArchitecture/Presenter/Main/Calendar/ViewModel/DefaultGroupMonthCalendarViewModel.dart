import 'dart:async';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthCalendarViewModel.dart';

class DefaultGroupMonthCalendarViewModel extends GroupMonthCalendarViewModel {
  Map<DateTime, List<Spend>> spendList = {};
  late GroupMonthCalendarActions groupMonthCalendarActions;
  late DateTime focuseDate = DateTime.now();
  late DateTime? selectedDate = null;
  int? groupMonthIdentity;

  final _dataController = StreamController<GroupMonthCalendarViewModel>();
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
  Future<void> fetchGroupMonth(int? groupMonthId) async {
    groupMonthIdentity = groupMonthId;
    GroupMonth? groupMonth =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupId(groupMonthId);

    spendList = convertGroupMonthToMap(groupMonth);

    this.focuseDate = groupMonth?.date ?? this.focuseDate;
    _dataController.add(this);
  }

  @override
  void reloadFetch() {
    fetchGroupMonth(groupMonthIdentity);
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
