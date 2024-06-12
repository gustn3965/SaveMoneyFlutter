import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/main.dart';

class SettingsViewModelListItem {
  String name;

  SettingsViewModelListItem(this.name);
}

class SettingsAction {
  void Function() clickToMoveLogin;
  void Function() clickChangeAppStatus;
  SettingsAction(this.clickToMoveLogin, this.clickChangeAppStatus);
}

abstract class SettingsViewModel {
  late List<SettingsViewModelListItem> list;

  late SettingsAction action;

  SettingsViewModel(this.action);

  // Observing
  Stream<SettingsViewModel> get dataStream;
  void dispose();

  void didClickCell(int index);
  void didChangeAppStatus(AppStatus appStatus);
}

class DefaultSettingsViewModel extends SettingsViewModel {
  DefaultSettingsViewModel(super.action) {
    fetchList();
  }

  final _dataController = StreamController<SettingsViewModel>.broadcast();
  @override
  Stream<SettingsViewModel> get dataStream => _dataController.stream;

  void fetchList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    list = [
      SettingsViewModelListItem("로그인화면"),
      SettingsViewModelListItem("지출 항목"),
      SettingsViewModelListItem("Dev - AppStatus"),
    ];

    _dataController.add(this);
  }

  @override
  void didClickCell(int index) {
    if (index == 0) {
      action.clickToMoveLogin();
    } else {
      print("아직 개발안됌");
    }
  }

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
