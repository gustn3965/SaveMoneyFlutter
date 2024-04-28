import 'package:save_money_flutter/CleanArchitecture/DIContainer/SettingsDIContainer.dart';

import 'EditSpendDIContainer.dart';
import 'HomeDIContainer.dart';
import 'LoginDIContainer.dart';
import 'MainTabDIContainer.dart';
import 'AddGroupDIContainer.dart';
import 'AddSpendDIContainer.dart';

enum AppStatus {
  demo,
  real,
}

// TODO: - appStatus에 따라 다르게 주입해주기 ( Widget, ViewModel, UseCase )
class AppDIContainer {
  AppStatus appStatus = AppStatus.demo;

  late LoginDIContainer login = LoginDIContainer(this.appStatus);

  late MainTabDIContainer mainTab = MainTabDIContainer(this.appStatus);

  late HomeDIContainer home = HomeDIContainer(this.appStatus);

  late AddSpendDIContainer addSpend = AddSpendDIContainer(this.appStatus);

  late EditSpendDIContainer editSpend = EditSpendDIContainer(this.appStatus);

  late AddGroupDIContainer addGroup = AddGroupDIContainer(this.appStatus);

  late SettingsDIContainer settings = SettingsDIContainer(this.appStatus);
}
