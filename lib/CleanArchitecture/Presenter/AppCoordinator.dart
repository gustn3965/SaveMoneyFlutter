import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SettingsCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import '../../AppColor/AppColors.dart';
import 'AddGroup/AddGroupCoordinator.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? currentContext = navigatorKey.currentContext;
}

abstract class Coordinator {
  Coordinator? superCoordinator;
  Coordinator? parentNavigationCoordinator;

  late Widget currentWidget;

  // 이니셜라이저에서 currentWidget을 초기화한다.
  Coordinator(this.superCoordinator, this.parentNavigationCoordinator) {
    superCoordinator?.childCoordinator.add(this);
  }

  // start로 시작하는 메소드는 currentWidget만 사용한다.
  void start() {
    NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
        settings: RouteSettings(
          name: routeName,
          arguments: this, // Coordinator전달
        ),
        builder: (context) => currentWidget));
  }

  // push가아닌 Navigation을 바꾼다.
  void startOnFirstNavigation() {
    NavigationService.navigatorKey.currentState?.popUntil((route) {
      bool isAppCoordinator =
          route.settings.name == (appCoordinator?.routeName ?? "");

      if (isAppCoordinator == false) {
        if (route.settings.arguments is Coordinator) {
          Coordinator coordinator = route.settings.arguments as Coordinator;
          coordinator.superCoordinator?.childCoordinator.remove(coordinator);
        }
      }
      return isAppCoordinator;
    });

    start();
  }

  void startFromModalBottomSheet() {
    showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context, ) {
        return DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
          builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(27),
                ),
                child: Container(
                  color: AppColors.whiteColor,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: currentWidget,
                  ),
                )
              );
      });
      },
    ).whenComplete(() {
      // pop();
    });
  }

  void pop() {
    NavigationService.navigatorKey.currentState?.pop();
    superCoordinator?.childCoordinator.remove(this);
  }

  void popUntilParentNavigation() {
    NavigationService.navigatorKey.currentState?.popUntil((route) {
      bool isParent =
          route.settings.name == (parentNavigationCoordinator?.routeName ?? "");

      if (isParent == false) {
        if (route.settings.arguments is Coordinator) {
          Coordinator coordinator = route.settings.arguments as Coordinator;
          coordinator.superCoordinator?.childCoordinator.remove(coordinator);
        }
      }
      return isParent;
    });
  }

  // 띄운화면을 닫을때 부모위젯을 업데이트하고자할때.
  void updateCurrentWidget();

  // 오버라이딩 불가하도로
  @nonVirtual
  void triggerTopUpdateWidget() {
    if (superCoordinator != null) {
      superCoordinator?.triggerTopUpdateWidget();
    } else {
      updateCurrentWidget();
    }
  }


  late String routeName;

  List<Coordinator> childCoordinator = [];
}

class AppCoordinator extends Coordinator {
  @override
  String routeName = "App";

  AppCoordinator(super.superCoordinator, super.parentNavigationCoordinator);

  @override
  void start() async {
    runApp(LanchScreenWidget());

    Future.delayed(const Duration(milliseconds: 1000), () {
      // showLoginView();
      showMainHomeView();
      // showSettinsView();
      // showAddSpendView();
    });
  }

  @override
  void pop() {}

  @override
  void updateCurrentWidget() {
    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  void showLoginView() {
    LoginCoordinator loginCoordinator = LoginCoordinator(this);
    loginCoordinator.startOnFirstNavigation();
  }

  void showMainHomeView() {
    MainTabCoordinator mainHomeCoordinator = MainTabCoordinator(this);
    mainHomeCoordinator.startOnFirstNavigation();
  }

  void showMainTabMoneyView() {}

  void showAddSpendView() {
    AddSpendCoordinator addSpendCoordinator =
        AddSpendCoordinator(this, DateTime.now(), null);
    addSpendCoordinator.startOnFirstNavigation();
  }

  void showSettinsView() {
    SettingsCoordinator coordinator = SettingsCoordinator(this);
    coordinator.startOnFirstNavigation();
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
