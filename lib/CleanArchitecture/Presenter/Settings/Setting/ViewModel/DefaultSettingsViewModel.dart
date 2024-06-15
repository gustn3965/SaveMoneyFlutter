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

    list = [
      SettingsViewModelListItem("Dev- 로그인화면"),
      SettingsViewModelListItem("소비 카테고리 목록"),
      SettingsViewModelListItem("Dev - AppStatus"),
    ];

    _dataController.add(this);
  }

  @override
  void didClickCell(int index) {
    if (index == 0) {
      action.clickToMoveLogin();
    } else {
      action.clickToMoveSpendCategorys();
    }
  }

  // AppStatus 접근하는건 좋지않아보이지만, 테스트용도이므로, 패스..
  @override
  void didChangeAppStatus(AppStatus appStatus) {
    appDIContainer.appStatus = appStatus;
    appDIContainer.changeAppStatus();

    _dataController.add(this);
    action.clickChangeAppStatus();
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
