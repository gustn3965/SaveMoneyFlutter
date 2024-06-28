import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';

class SettingsViewModelListItem {
  String name;

  void Function() doAction;

  SettingsViewModelListItem({required this.name, required this.doAction});
}

class SettingsAction {
  void Function() clickToMoveLogin;
  void Function() clickToMoveSpendCategorys;
  void Function() clickToMoveGroupCategorys;
  void Function() clickToShowAppNotice;
  void Function() clickChangeAppStatus;

  SettingsAction(
      {required this.clickToMoveLogin,
      required this.clickToMoveSpendCategorys,
      required this.clickToMoveGroupCategorys,
      required this.clickToShowAppNotice,
      required this.clickChangeAppStatus});
}

abstract class SettingsViewModel {
  late List<SettingsViewModelListItem> list;

  late SettingsAction action;

  SettingsViewModel(this.action);

  // Observing
  Stream<SettingsViewModel> get dataStream;

  void dispose();

  void reloadData();

  void didClickCell(int index);
}
