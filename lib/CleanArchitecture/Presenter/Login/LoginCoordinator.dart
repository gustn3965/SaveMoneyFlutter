import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';

import 'AddGroupName/ViewModel/LoginAddGroupNameViewModel.dart';
import 'AddGroupMoney/ViewModel/LoginAddGroupMoneyViewModel.dart';

import '../../../main.dart';

class LoginCoordinator extends Coordinator {
  LoginAddGroupNameViewModel? loginAddGroupNameViewModel;
  LoginAddGroupMoneyViewModel? loginAddGroupMoneyViewModel;

  @override
  void pop() {
    NavigationService.navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == (superCoordinator?.routeName ?? ""));
    superCoordinator?.childCoordinator.remove(this);
  }

  @override
  void start() {
    showAddGroupWidget();
    // TODO: implement start
  }

  void showAddGroupWidget() {
    Navigator.pushAndRemoveUntil(
        NavigationService.currentContext!,
        MaterialPageRoute(
          builder: (context) => makeLoginAddGroupNameWidget(),
        ),
        (route) => false);
  }

  void showMainHomeWidget() {
    pop();

    coordinator.showMainHomeView(null);
  }

  Widget makeLoginAddGroupNameWidget() {
    void addGroupName(DateTime date, String groupName) {
      Navigator.push(
        NavigationService.currentContext!,
        MaterialPageRoute(
          builder: (context) => makeLoginAddGroupMoneyWidget(date, groupName),
        ),
      );
    }

    LoginAddGroupNameActions action = LoginAddGroupNameActions(
      addGroupName,
    );

    loginAddGroupNameViewModel = appDIContainer.login
        .makeLoginAddGroupNameViewModel(DateTime.now(), action);

    return appDIContainer.login
        .makeLoginAddGroupNameWidget(loginAddGroupNameViewModel!);
  }

  Widget makeLoginAddGroupMoneyWidget(DateTime date, String categoryName) {
    void didAddNewGroup() {
      showMainHomeWidget();
    }

    void cancelAddGroupMoney() {
      Navigator.pop(NavigationService.currentContext!);
    }

    LoginAddGroupMoneyAction action = LoginAddGroupMoneyAction(
      didAddNewGroup,
      cancelAddGroupMoney,
    );

    loginAddGroupMoneyViewModel = appDIContainer.login
        .makeLoginAddGroupMoneyViewModel(date, categoryName, action);
    return appDIContainer.login
        .makeLoginAddGroupMoneyWidget(loginAddGroupMoneyViewModel!);
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }
}
