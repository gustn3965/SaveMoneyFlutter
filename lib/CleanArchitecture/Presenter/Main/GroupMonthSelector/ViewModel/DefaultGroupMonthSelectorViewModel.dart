import 'dart:async';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import 'GroupMonthSelectorViewModel.dart';

class DefaultGroupMonthSelectorViewModel extends GroupMonthSelectorViewModel {
  late List<GroupMonth> groupMonthList;
  late GroupMonth? selectedGroupMonth;
  final GroupMonthFetchUseCase groupMonthFetchUseCase;
  final GroupMonthSelectorActions groupMonthSelectorActions;

  final _dataController =
      StreamController<GroupMonthSelectorViewModel>.broadcast();

  @override
  Stream<GroupMonthSelectorViewModel> get dataStream => _dataController.stream;

  DefaultGroupMonthSelectorViewModel(
      this.groupMonthFetchUseCase, this.groupMonthSelectorActions) {
    groupMonthList = [];
    selectedGroupMonth = null;
  }

  @override
  void didSelectGroupMonth(GroupMonth? selectedGroupMonth) {
    this.selectedGroupMonth = selectedGroupMonth;
    _dataController.add(this);
    groupMonthSelectorActions.updateSelectedGroupMonth(selectedGroupMonth);
  }

  @override
  void didSelectAddGroupMonth() {
    selectedGroupMonth = null; // 새로운 GroupMonth를 추가할 때는 선택된 것 없음
    _dataController.add(this);
  }

  @override
  Future<void> fetchGroupMonthList(DateTime date) async {
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
  void dispose() {
    _dataController.close();
  }
}
