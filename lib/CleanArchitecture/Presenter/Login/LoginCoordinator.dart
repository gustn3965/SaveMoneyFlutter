import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/AddGroupMoney/ViewModel/DefaultLoginAddGroupMoneyViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/AddGroupMoney/Widget/LoginAddGroupMoneyWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/AddGroupName/ViewModel/DefaultLoginAddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/AddGroupName/ViewModel/LoginAddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/AddGroupName/Widget/LoginAddGroupNameWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupMonthUseCase.dart';

import '../../../main.dart';
import 'AddGroupMoney/ViewModel/LoginAddGroupMoneyViewModel.dart';

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
          settings: RouteSettings(name: "/Page2"),
          builder: (context) => makeLoginAddGroupNameWidget(),
        ),
        (route) => false);
    // Navigator.push(
    //
    // );
  }

  void showMainHomeWidget() {
    // Navigator.popUntil(NavigationService.currentContext!, (route) => false);
    pop();

    coordinator.showMainHomeView(null);

    // Navigator.pushAndRemoveUntil(NavigationService.currentContext!, newRoute, (route) => false)
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

    loginAddGroupNameViewModel =
        DefaultLoginAddGroupNameViewModel(DateTime.now(), action);
    return LoginAddGroupNameWidget(loginAddGroupNameViewModel!);
  }

  Widget makeLoginAddGroupMoneyWidget(DateTime dateTime, String categoryName) {
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

    loginAddGroupMoneyViewModel = DefaultLoginAddGroupMoneyViewModel(
        dateTime,
        categoryName,
        action,
        MockAddGroupMonthUseCase(),
        MockAddGroupCategoryUseCase());
    return LoginAddGroupMoneyWidget(loginAddGroupMoneyViewModel!);
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }
}
