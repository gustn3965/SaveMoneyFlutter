
import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupMonthMoney/ViewModel/EditGroupMonthMoneyViewModel.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';

class EditGroupMonthMoneyCoordinator extends Coordinator {
  EditGroupMonthMoneyViewModel? editGroupMonthMoneyViewModel;

  EditGroupMonthMoneyCoordinator(
      {required Coordinator? superCoordinator,
        required Coordinator? parentTabCoordinator,
        required String groupMonthId})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "AddMoney";
    currentWidget = makeEditGroupMonthMoneyWidget(groupMonthId);
  }

  @override
  void updateCurrentWidget() {
    editGroupMonthMoneyViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeEditGroupMonthMoneyWidget(String groupMonthId) {
    void didEditGroupMonthMoney() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void didCancelEdit() {
      pop();
    }

    EditGroupMonthMoneyAction actions = EditGroupMonthMoneyAction(
      didEditGroupMonthMoney,
      didCancelEdit,
    );
    editGroupMonthMoneyViewModel ??= appDIContainer.settings
        .makeEditGroupMonthMoneyViewModel(actions, groupMonthId);
    return appDIContainer.settings
        .makeEditGroupMonthMoneyWidget(editGroupMonthMoneyViewModel!);
  }
}