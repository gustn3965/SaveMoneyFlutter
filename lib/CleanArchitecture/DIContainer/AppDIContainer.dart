import 'LoginDIContainer.dart';
import 'MainDIContainer.dart';
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

  late MainDIContainer main = MainDIContainer(this.appStatus);

  late AddSpendDIContainer addSpend = AddSpendDIContainer(this.appStatus);

  late AddGroupDIContainer addGroup = AddGroupDIContainer(this.appStatus);
}
