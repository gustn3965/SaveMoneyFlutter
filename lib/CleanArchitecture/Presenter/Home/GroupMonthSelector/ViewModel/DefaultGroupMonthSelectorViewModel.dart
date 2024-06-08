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
  late List<GroupMonth> selectedGroupMonths;
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
    selectedGroupMonths = [];
    addGroupButtonName = "+ 지출 그룹 추가";

    fetchGroupMonthList(DateTime.now());
  }

  @override
  void didSelectGroupMonth(GroupMonth selectedGroupMonth) {
    if (selectedGroupMonths.contains(selectedGroupMonth)) {
      selectedGroupMonths.remove(selectedGroupMonth);
    } else {
      selectedGroupMonths.add(selectedGroupMonth);
    }

    _dataController.add(this);

    List<String> groupMonthsIds = selectedGroupMonths.map((group) {
      return group.identity;
    }).toList();
    groupMonthSelectorActions.updateSelectedGroupIds(groupMonthsIds);
  }

  @override
  void didSelectAddGroupMonth() {
    groupMonthSelectorActions.showAddGroup();
  }

  // 기존에 선택된 그룹들기반으로, 카테고리가 맞는 새로운 selectedGroupMonths를 만들어줌.
  @override
  Future<void> fetchGroupMonthList(DateTime date) async {
    fetchedDate = date;
    try {
      groupMonthList = await groupMonthFetchUseCase.fetchGroupMonthList(date);
      _dataController.add(this);

      selectedGroupMonths = makeNewSelectedGroupMonth(groupMonthList);

      List<String> groupMonthsIds = selectedGroupMonths.map((group) {
        return group.identity;
      }).toList();
      groupMonthSelectorActions.updateSelectedGroupIds(groupMonthsIds);
    } catch (e) {
      print("error");
      // 에러 처리
    }
  }

  List<GroupMonth> makeNewSelectedGroupMonth(
      List<GroupMonth> fetchedNewGroupMonths) {
    List<GroupMonth> newSelectedGroupMonth = [];
    for (GroupMonth group in groupMonthList) {
      List<String> groupCategoryIds = selectedGroupMonths.map((group) {
        return group.groupCategory.identity;
      }).toList();
      if (groupCategoryIds.contains(group.groupCategory.identity)) {
        newSelectedGroupMonth.add(group);
      }
    }
    return newSelectedGroupMonth;
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
