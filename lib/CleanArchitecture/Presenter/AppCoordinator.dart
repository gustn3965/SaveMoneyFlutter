import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SettingsCoordinator.dart';

import 'AddGroup/AddGroupCoordinator.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? currentContext =
      NavigationService.navigatorKey.currentContext;
}

abstract class Coordinator {
  Coordinator? superCoordinator;
  late Widget currentWidget;

  // 이니셜라이저에서 currentWidget을 초기화한다.
  Coordinator(this.superCoordinator) {
    superCoordinator?.childCoordinator.add(this);
  }

  // start로 시작하는 메소드는 currentWidget만 사용한다.
  void start();

  void pop() {
    NavigationService.navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == (superCoordinator?.routeName ?? ""));
    superCoordinator?.childCoordinator.remove(this);
  }

  void updateCurrentWidget();

  late String routeName;

  List<Coordinator> childCoordinator = [];
}

class AppCoordinator extends Coordinator {
  @override
  String routeName = "App";

  AppCoordinator(super.superCoordinator);

  @override
  void start() {
    runApp(LanchScreenWidget());

    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pop(NavigationService.currentContext!);

      showLoginView();
      // showMainHomeView(null);
      // showSettinsView(null);

      // TESTAddSpendWidget();
      // TESTAddGroupWidget();
    });
  }

  @override
  void pop() {}

  @override
  void updateCurrentWidget() {}

  void showLoginView() {
    LoginCoordinator loginCoordinator = LoginCoordinator(this);
    // (parentCoordinator ?? this).childCoordinator.add(loginCoordinator);
    loginCoordinator.start();
  }

  void showMainHomeView(Coordinator? parentCoordinator) {
    MainTabCoordinator mainHomeCoordinator = MainTabCoordinator(this);
    // mainHomeCoordinator.superCoordinator = parentCoordinator ?? this;
    mainHomeCoordinator.start();
    // (parentCoordinator ?? this).childCoordinator.add(mainHomeCoordinator);
  }

  void showMainTabMoneyView() {}

  void showAddSpendView(
      Coordinator? parentCoordinator, bool isModal, DateTime date) {
    AddSpendCoordinator addSpendCoordinator = AddSpendCoordinator(this, date);
    addSpendCoordinator.superCoordinator = parentCoordinator ?? this;
    // if (isModal) {
    //   addSpendCoordinator.startFromModalBottomSheet(date);
    // } else {
    addSpendCoordinator.start();
    // }

    // (parentCoordinator ?? this).childCoordinator.add(addSpendCoordinator);
  }

  void showSettinsView(Coordinator? parentCoordinatore) {
    SettingsCoordinator coordinator = SettingsCoordinator(this);
    // coordinator.superCoordinator = parentCoordinatore ?? this;
    coordinator.start();
    // (parentCoordinatore ?? this).childCoordinator.add(coordinator);
  }

  // void TESTAddSpendWidget() {
  //   AddSpendCoordinator addSpendCoordinator = AddSpendCoordinator();
  //   addSpendCoordinator.start();
  //   childCoordinator.add(addSpendCoordinator);
  // }
  //
  // void TESTAddGroupWidget() {
  //   AddGroupCoordinator addGroupCoordinator = AddGroupCoordinator();
  //   addGroupCoordinator.start();
  //   childCoordinator.add(addGroupCoordinator);
  // }
}

class LanchScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      home: const Scaffold(
        backgroundColor: Colors.white,
      ),
    );
  }
}
