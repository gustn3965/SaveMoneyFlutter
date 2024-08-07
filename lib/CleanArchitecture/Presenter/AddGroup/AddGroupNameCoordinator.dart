import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoneyCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppGuide/AppGuideCoordinator.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';
import 'AddGroupName/ViewModel/AddGroupNameViewModel.dart';

class AddGroupNameCoordinator extends Coordinator {
  AddGroupNameViewModel? addGroupNameViewModel;

  AddGroupNameCoordinator(
      {required Coordinator? superCoordinator,
      required Coordinator? parentTabCoordinator,
      required DateTime date})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "AddName";
    currentWidget = makeAddGroupNameWidget(date);
  }

  @override
  void updateCurrentWidget() {

    addGroupNameViewModel?.reloadData();
    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeAddGroupNameWidget(DateTime date) {
    void cancelAddGroupName() {
      pop();
    }

    void addGroupName(DateTime date, String groupName) {
      AddGroupMoneyCoordinator addGroupMoneyCoordinator =
          AddGroupMoneyCoordinator(
              superCoordinator: this,
              parentTabCoordinator: parentNavigationCoordinator,
              date: date,
              groupName: groupName);
      addGroupMoneyCoordinator.start();
    }

    void hasAlreadyCategoryName() {
      showHasAlreadyCategoryNameAlert();
    }

    void showAppGuideWidget() {
      void didClickNextButton() {
        print("done");
      }
      AppGuideCoordinator appGuideCoordinator = AppGuideCoordinator(superCoordinator: this, parentTabCoordinator: this, showNextWidget: didClickNextButton);
      appGuideCoordinator.start();
    }

    AddGroupNameActions actions = AddGroupNameActions(
      cancelAddGroupName,
      addGroupName,
      hasAlreadyCategoryName,
        showAppGuideWidget
    );

    addGroupNameViewModel ??=
        appDIContainer.addGroup.makeAddGroupNameViewModel(date, actions);

    return appDIContainer.addGroup
        .makeAddGroupNameWidget(addGroupNameViewModel!);
  }

  void showHasAlreadyCategoryNameAlert() {
    showCupertinoDialog<void>(
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
