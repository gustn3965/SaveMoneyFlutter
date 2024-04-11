import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/DefaultAddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/Widget/AddGroupListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoney/Widget/AddGroupMoneyWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/DefaultAddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/Widget/AddGroupNameWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupMonthUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';

import 'AddGroupMoney/ViewModel/DefaultAddGroupMoneyViewModel.dart';

class AddGroupCoordinator extends Coordinator {
  AddGroupListViewModel? groupListviewModel;
  AddGroupNameViewModel? addGroupNameViewModel;
  AddGroupMoneyViewModel? addGroupMoneyViewModel;

  BuildContext? addGroupContext;

  @override
  void pop() {
    RoutePredicate superRouter =
        ModalRoute.withName(superCoordinator!.mainPageName);
    Navigator.popUntil(addGroupContext!, superRouter);

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
        builder: (context) => makeAddGroupWidget(date),
      ),
    );
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddGroupWidget(DateTime date) {
    void addCurrentGroup(DateTime date, String groupName) {}
    ;

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

    AddGroupListViewModel groupListviewModel = DefaultAddGroupListViewModel(
        date, MockGroupCategoryFetchUseCase(), actions);
    this.groupListviewModel = groupListviewModel;

    return AddGroupListWidget(groupListviewModel);
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

    AddGroupNameActions actions = AddGroupNameActions(
      cancelAddGroupName,
      addGroupName,
    );

    addGroupNameViewModel = DefaultAddGroupNameViewModel(date, actions);

    return AddGroupNameWidget(addGroupNameViewModel!);
  }

  Widget makeAddGroupMoneyWidget(DateTime date, String groupName) {
    void didAddNewGroup() {
      superCoordinator?.updateCurrentWidget();
      pop();
    }

    void cancelAddGroupMoney() {
      Navigator.pop(NavigationService.currentContext!);
    }

    AddGroupMoneyAction actions = AddGroupMoneyAction(
      didAddNewGroup,
      cancelAddGroupMoney,
    );
    addGroupMoneyViewModel = DefaultAddGroupMoneyViewModel(date, groupName,
        actions, MockAddGroupMonthUseCase(), MockAddGroupCategoryUseCase());

    return AddGroupMoneyWidget(addGroupMoneyViewModel!);
  }

  void TEST() {
    Widget addGroupListWidget = makeAddGroupWidget(DateTime.now());
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => addGroupListWidget,
      ),
    );
  }
}
