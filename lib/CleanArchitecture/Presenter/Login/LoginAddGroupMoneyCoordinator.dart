import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';
import '../Main/MainTabCoordinator.dart';
import 'AddGroupMoney/ViewModel/LoginAddGroupMoneyViewModel.dart';

class LoginAddGroupMoneyCoordinator extends Coordinator {
  LoginAddGroupMoneyViewModel? addGroupMoneyViewModel;

  LoginAddGroupMoneyCoordinator(
      {required Coordinator? superCoordinator,
      required Coordinator? parentTabCoordinator,
      required DateTime date,
      required String groupName})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "AddMoney";
    currentWidget = makeAddGroupMoneyWidget(date, groupName);
  }

  @override
  void updateCurrentWidget() {
    addGroupMoneyViewModel?.reloadData();
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddGroupMoneyWidget(DateTime date, String groupName) {
    void didAddNewGroup() {
      showMainHomeWidget();
    }

    void cancelAddGroupMoney() {
      pop();
    }

    LoginAddGroupMoneyAction action = LoginAddGroupMoneyAction(
      didAddNewGroup,
      cancelAddGroupMoney,
    );

    addGroupMoneyViewModel ??= appDIContainer.login
        .makeLoginAddGroupMoneyViewModel(date, groupName, action);
    return appDIContainer.login
        .makeLoginAddGroupMoneyWidget(addGroupMoneyViewModel!);
  }

  void showMainHomeWidget() async {
    popUntilParentNavigation();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstInstall', false);
    MainTabCoordinator mainHomeCoordinator = MainTabCoordinator(appCoordinator);
    mainHomeCoordinator.startOnFirstNavigation();
  }
}
