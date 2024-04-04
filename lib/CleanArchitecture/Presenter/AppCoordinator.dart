import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainHomeCoordinator.dart';

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

  List<Coordinator> childCoordinator = [];
}

class AppCoordinator extends Coordinator {
  @override
  void start() {
    runApp(LanchScreenWidget());

    Future.delayed(const Duration(milliseconds: 500), () {
      showMainHomeView();
      // TESTAddSpendWidget();
    });
  }

  @override
  void pop() {}

  void showLoginView() {}

  void showMainHomeView() {
    MainHomeCoordinator mainHomeCoordinator = MainHomeCoordinator();
    mainHomeCoordinator.start();
    childCoordinator.add(mainHomeCoordinator);
  }

  void TESTAddSpendWidget() {
    AddSpendCoordinator addSpendCoordinator = AddSpendCoordinator();
    addSpendCoordinator.start();
    childCoordinator.add(addSpendCoordinator);
  }

  @override
  void updateCurrentWidget() {}
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
