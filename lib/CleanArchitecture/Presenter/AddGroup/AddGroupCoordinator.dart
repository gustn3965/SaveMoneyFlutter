import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import '../../UseCase/GroupMonthFetchUseCase.dart';
import 'AddGroupMoney/ViewModel/DefaultAddGroupMoneyViewModel.dart';

class AddGroupCoordinator extends Coordinator {
  AddGroupListViewModel? groupListviewModel;
  AddGroupNameViewModel? addGroupNameViewModel;
  AddGroupMoneyViewModel? addGroupMoneyViewModel;

  BuildContext? addGroupContext;

  @override
  void pop() {
    NavigationService.navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == (superCoordinator?.routeName ?? ""));
    superCoordinator?.childCoordinator.remove(this);
  }

  @override
  void start() {
    TEST();
  }

  void startFromDate(DateTime date) {
    addGroupContext = NavigationService.currentContext!;
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        settings: RouteSettings(name: "/Page1"),
        builder: (context) => makeAddGroupListWidget(date),
      ),
    );
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddGroupListWidget(DateTime date) {
    void addCurrentGroup(DateTime date, String groupName) {
      Navigator.push(
        NavigationService.currentContext!,
        MaterialPageRoute(
          builder: (context) => makeAddGroupMoneyWidget(date, groupName),
        ),
      );
    }

    void addNewGroup(DateTime date) {
      Navigator.push(
        NavigationService.currentContext!,
        MaterialPageRoute(
          builder: (context) => makeAddGroupNameWidget(date),
        ),
      );
    }

    AddGroupListActions actions = AddGroupListActions(
      addNewGroup,
      addCurrentGroup,
    );

    AddGroupListViewModel groupListviewModel =
        appDIContainer.addGroup.makeAddGroupListViewModel(date, actions);
    this.groupListviewModel = groupListviewModel;

    return appDIContainer.addGroup.makeAddGroupListWidget(groupListviewModel);
  }

  Widget makeAddGroupNameWidget(DateTime date) {
    void cancelAddGroupName() {
      Navigator.pop(NavigationService.currentContext!);
    }

    void addGroupName(DateTime date, String groupName) {
      Navigator.push(
        NavigationService.currentContext!,
        MaterialPageRoute(
          builder: (context) => makeAddGroupMoneyWidget(date, groupName),
        ),
      );
    }

    void hasAlreadyCategoryName() {
      showHasAlreadyCategoryNameAlert();
    }

    AddGroupNameActions actions = AddGroupNameActions(
      cancelAddGroupName,
      addGroupName,
      hasAlreadyCategoryName,
    );

    addGroupNameViewModel =
        appDIContainer.addGroup.makeAddGroupNameViewModel(date, actions);

    return appDIContainer.addGroup
        .makeAddGroupNameWidget(addGroupNameViewModel!);
  }

  Widget makeAddGroupMoneyWidget(DateTime date, String groupName) {
    void didAddNewGroup() {
      pop();
      superCoordinator?.updateCurrentWidget();
    }

    void cancelAddGroupMoney() {
      Navigator.pop(NavigationService.currentContext!);
    }

    AddGroupMoneyAction actions = AddGroupMoneyAction(
      didAddNewGroup,
      cancelAddGroupMoney,
    );
    addGroupMoneyViewModel = appDIContainer.addGroup
        .makeAddGroupMoneyViewModel(date, groupName, actions);
    return appDIContainer.addGroup
        .makeAddGroupMoneyWidget(addGroupMoneyViewModel!);
  }

  void showHasAlreadyCategoryNameAlert() {
    showCupertinoModalPopup<void>(
      context: NavigationService.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          '이미 같은 이름이 존재합니다.',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(NavigationService.currentContext!);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void TEST() {
    Widget addGroupListWidget = makeAddGroupListWidget(DateTime.now());
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => addGroupListWidget,
      ),
    );
  }
}
