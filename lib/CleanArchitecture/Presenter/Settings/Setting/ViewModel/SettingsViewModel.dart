import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';

class SettingsViewModelListItem {
  String name;

  SettingsViewModelListItem(this.name);
}

class SettingsAction {
  void Function() clickToMoveLogin;
  void Function() clickToMoveSpendCategorys;
  void Function() clickChangeAppStatus;
  SettingsAction(
      {required this.clickToMoveLogin,
      required this.clickToMoveSpendCategorys,
      required this.clickChangeAppStatus});
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