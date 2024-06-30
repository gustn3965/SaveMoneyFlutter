import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';
import 'AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';

class AddGroupMoneyCoordinator extends Coordinator {
  AddGroupMoneyViewModel? addGroupMoneyViewModel;

  AddGroupMoneyCoordinator(
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
  }

  Widget makeAddGroupMoneyWidget(DateTime date, String groupName) {
    void didAddNewGroup() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      popUntilParentNavigation();
    }

    void cancelAddGroupMoney() {
      pop();
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
}
