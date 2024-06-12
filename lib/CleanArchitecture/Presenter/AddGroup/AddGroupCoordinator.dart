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

  AddGroupCoordinator(Coordinator? superCoordinator, DateTime date)
      : super(superCoordinator) {
    routeName = "AddGroup";
    currentWidget = makeAddGroupListWidget(date);
  }

  @override
  void start() {
    NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => currentWidget,
    ));
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddGroupListWidget(DateTime date) {
    void addCurrentGroup(DateTime date, String groupName) {
      NavigationService.navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => makeAddGroupMoneyWidget(date, groupName),
        ),
      );
    }

    void addNewGroup(DateTime date) {
      addGroupNameViewModel = null;
      NavigationService.navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => makeAddGroupNameWidget(date),
        ),
      );
    }

    void navigationPop() {
      pop();
    }

    AddGroupListActions actions = AddGroupListActions(
      addNewGroup,
      addCurrentGroup,
      navigationPop,
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
      addGroupMoneyViewModel = null;
      NavigationService.navigatorKey.currentState!.push(
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

    addGroupNameViewModel ??=
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
      addGroupMoneyViewModel = null;
      Navigator.pop(NavigationService.currentContext!);
    }

    AddGroupMoneyAction actions = AddGroupMoneyAction(
      didAddNewGroup,
      cancelAddGroupMoney,
    );
    addGroupMoneyViewModel ??= appDIContainer.addGroup
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
}
