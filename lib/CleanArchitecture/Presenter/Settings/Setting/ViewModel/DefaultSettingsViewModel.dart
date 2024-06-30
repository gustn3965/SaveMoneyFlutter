import 'dart:async';

import '../../../../../main.dart';
import '../../../../DIContainer/AppDIContainer.dart';
import 'SettingsViewModel.dart';

class DefaultSettingsViewModel extends SettingsViewModel {
  DefaultSettingsViewModel(super.action) {
    fetchList();
  }

  @override
  late List<SettingsViewModelListItem> list = [];

  final _dataController = StreamController<SettingsViewModel>.broadcast();
  @override
  Stream<SettingsViewModel> get dataStream => _dataController.stream;

  void fetchList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    List<SettingsViewModelListItem> items = [];
    switch (appDIContainer.appStatus) {
      case AppStatus.mock || AppStatus.cbt:
        items = [
          SettingsViewModelListItem(name: "공지사항", doAction: action.clickToShowAppNotice),
          SettingsViewModelListItem(name: "바인더 목록", doAction: action.clickToMoveGroupCategorys),
          SettingsViewModelListItem(name: "소비 카테고리 목록", doAction: action.clickToMoveSpendCategorys),
          SettingsViewModelListItem(name: "Dev- 로그인화면", doAction: action.clickToMoveLogin),
          SettingsViewModelListItem(name: "Dev- 모든 데이터 삭제", doAction: action.clickAllDeleteTableDataSet)
        ];
        break;
      case AppStatus.real:
        items = [
          SettingsViewModelListItem(name: "공지사항", doAction: action.clickToShowAppNotice),
          SettingsViewModelListItem(name: "바인더 목록", doAction: action.clickToMoveGroupCategorys),
          SettingsViewModelListItem(name: "소비 카테고리 목록", doAction: action.clickToMoveSpendCategorys)
        ];
        break;
    }
    list = items;

    _dataController.add(this);
  }

  @override
  void didClickCell(int index) {
    list[index].doAction();
  }

  @override
  void reloadData() {
    fetchList();
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
