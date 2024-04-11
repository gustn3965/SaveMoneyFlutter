import 'dart:async';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthSelectorViewModel.dart';

class DefaultGroupMonthSelectorViewModel extends GroupMonthSelectorViewModel {
  @override
  final GroupMonthSelectorActions groupMonthSelectorActions;
  @override
  late List<GroupMonth> groupMonthList;
  @override
  late GroupMonth? selectedGroupMonth;
  @override
  late String addGroupButtonName;

  final GroupMonthFetchUseCase groupMonthFetchUseCase;
  late DateTime fetchedDate;

  final _dataController =
      StreamController<GroupMonthSelectorViewModel>.broadcast();

  @override
  Stream<GroupMonthSelectorViewModel> get dataStream => _dataController.stream;

  DefaultGroupMonthSelectorViewModel(
      this.groupMonthFetchUseCase, this.groupMonthSelectorActions) {
    groupMonthList = [];
    selectedGroupMonth = null;
    addGroupButtonName = "+ 지출 그룹 추가";

    fetchGroupMonthList(DateTime.now());
  }

  @override
  void didSelectGroupMonth(GroupMonth? selectedGroupMonth) {
    this.selectedGroupMonth = selectedGroupMonth;
    _dataController.add(this);
    groupMonthSelectorActions.updateSelectedGroupMonth(selectedGroupMonth);
  }

  @override
  void didSelectAddGroupMonth() {
    groupMonthSelectorActions.showAddGroup();
  }

  @override
  Future<void> fetchGroupMonthList(DateTime date) async {
    fetchedDate = date;
    try {
      groupMonthList = await groupMonthFetchUseCase.fetchGroupMonthList(date);
      _dataController.add(this);

      var hasSameGroupCategory = false;
      for (var group in groupMonthList) {
        if (this.selectedGroupMonth?.groupCategory.identity ==
            group.groupCategory.identity) {
          didSelectGroupMonth(group);
          hasSameGroupCategory = true;
          // break;
        }
      }
      if (hasSameGroupCategory == false) {
        didSelectGroupMonth(null);
      }
    } catch (e) {
      print("error");
      // 에러 처리
    }
  }

  @override
  void reloadFetch() {
    fetchGroupMonthList(fetchedDate);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
