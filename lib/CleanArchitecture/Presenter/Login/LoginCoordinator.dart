import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppGuide/AppGuideCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginAddGroupMoneyCoordinator.dart';

import 'AddGroupName/ViewModel/LoginAddGroupNameViewModel.dart';

import '../../../main.dart';

class LoginCoordinator extends Coordinator {
  LoginAddGroupNameViewModel? loginAddGroupNameViewModel;

  LoginCoordinator(Coordinator? superCoordinator)
      : super(superCoordinator, null) {
    routeName = "Login";
    currentWidget = makeLoginAddGroupNameWidget();
  }

  @override
  void updateCurrentWidget() {
    loginAddGroupNameViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
    // TODO: implement updateCurrentWidget
  }

  @override
  void start() {
    super.start();

    void showNextWidget() {

    }
    AppGuideCoordinator appGuideCoordinator = AppGuideCoordinator(superCoordinator: this, parentTabCoordinator: this, showNextWidget: showNextWidget);
    appGuideCoordinator.start();
  }

  Widget makeLoginAddGroupNameWidget() {
    void addGroupName(DateTime date, String groupName) {
      LoginAddGroupMoneyCoordinator loginAddGroupMoneyCoordinator =
          LoginAddGroupMoneyCoordinator(
              superCoordinator: this,
              parentTabCoordinator: this,
              date: date,
              groupName: groupName);
      loginAddGroupMoneyCoordinator.start();
    }

    LoginAddGroupNameActions action = LoginAddGroupNameActions(
      addGroupName,
    );

    loginAddGroupNameViewModel = appDIContainer.login
        .makeLoginAddGroupNameViewModel(DateTime.now(), action);

    return appDIContainer.login
        .makeLoginAddGroupNameWidget(loginAddGroupNameViewModel!);
  }
}
