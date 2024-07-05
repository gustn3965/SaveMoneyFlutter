import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupNameCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import '../../UseCase/GroupMonthFetchUseCase.dart';
import 'AddGroupMoney/ViewModel/DefaultAddGroupMoneyViewModel.dart';
import 'AddGroupMoneyCoordinator.dart';

class AddGroupCoordinator extends Coordinator {
  AddGroupListViewModel? groupListviewModel;

  AddGroupCoordinator(Coordinator? superCoordinator, DateTime date)
      : super(superCoordinator, null) {
    routeName = "AddGroup";
    currentWidget = makeAddGroupListWidget(date);
  }

  @override
  void updateCurrentWidget() {
    groupListviewModel?.fetchGroupCategoryList();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeAddGroupListWidget(DateTime date) {
    void addCurrentGroup(DateTime date, String groupName) {
      AddGroupMoneyCoordinator addGroupMoneyCoordinator =
          AddGroupMoneyCoordinator(
              superCoordinator: this,
              parentTabCoordinator: this,
              date: date,
              groupName: groupName);
      addGroupMoneyCoordinator.start();
    }

    void addNewGroup(DateTime date) {
      AddGroupNameCoordinator addGroupNameCoordinator = AddGroupNameCoordinator(
          superCoordinator: this, parentTabCoordinator: this, date: date);
      addGroupNameCoordinator.start();
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
}
