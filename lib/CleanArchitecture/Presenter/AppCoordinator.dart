import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainHomeCoordinator.dart';

import 'AddGroup/AddGroupCoordinator.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? currentContext =
      NavigationService.navigatorKey.currentContext;
}

abstract class Coordinator {
  Coordinator? superCoordinator;

  void start();

  void pop();

  void updateCurrentWidget();

  late String routeName;

  List<Coordinator> childCoordinator = [];
}

class AppCoordinator extends Coordinator {
  @override
  String routeName = "App";

  @override
  void start() {
    runApp(LanchScreenWidget());

    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pop(NavigationService.currentContext!);

      showLoginView(null);
      // showMainHomeView(null);
      // TESTAddSpendWidget();
      // TESTAddGroupWidget();
    });
  }

  @override
  void pop() {}

  @override
  void updateCurrentWidget() {}

  void showLoginView(Coordinator? parentCoordinator) {
    LoginCoordinator loginCoordinator = LoginCoordinator();
    loginCoordinator.superCoordinator = parentCoordinator ?? this;
    loginCoordinator.start();
    (parentCoordinator ?? this).childCoordinator.add(loginCoordinator);
  }

  void showMainHomeView(Coordinator? parentCoordinator) {
    MainHomeCoordinator mainHomeCoordinator = MainHomeCoordinator();
    mainHomeCoordinator.superCoordinator = parentCoordinator ?? this;
    mainHomeCoordinator.start();
    (parentCoordinator ?? this).childCoordinator.add(mainHomeCoordinator);
  }

  void showAddSpendView(
      Coordinator? parentCoordinator, bool isModal, DateTime date) {
    AddSpendCoordinator addSpendCoordinator = AddSpendCoordinator();
    addSpendCoordinator.superCoordinator = parentCoordinator ?? this;
    if (isModal) {
      addSpendCoordinator.startFromModalBottomSheet(date);
    } else {
      addSpendCoordinator.start();
    }

    (parentCoordinator ?? this).childCoordinator.add(addSpendCoordinator);
  }

  void showAddGroupMonthView(Coordinator? parentCoordinator, DateTime date) {
    AddGroupCoordinator addGroupCoordinator = AddGroupCoordinator();
    addGroupCoordinator.superCoordinator = parentCoordinator ?? this;
    addGroupCoordinator.startFromDate(date);
    (parentCoordinator ?? this).childCoordinator.add(addGroupCoordinator);
  }

  void TESTAddSpendWidget() {
    AddSpendCoordinator addSpendCoordinator = AddSpendCoordinator();
    addSpendCoordinator.start();
    childCoordinator.add(addSpendCoordinator);
  }

  void TESTAddGroupWidget() {
    AddGroupCoordinator addGroupCoordinator = AddGroupCoordinator();
    addGroupCoordinator.start();
    childCoordinator.add(addGroupCoordinator);
  }
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
