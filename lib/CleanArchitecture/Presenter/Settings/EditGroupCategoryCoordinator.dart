import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupMonthMoneyCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditSpendCategory/ViewModel/EditSpendCategoryViewModel.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';
import 'EditGroupCategory/ViewModel/EditGroupCategoryViewModel.dart';

class EditGroupCategoryCoordinator extends Coordinator {
  EditGroupCategoryViewModel? editGroupCategoryViewModel;

  EditGroupCategoryCoordinator(
      {required Coordinator superCoordinator,
      required Coordinator parentTabCoordinator,
      required String groupCategoryId})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "EditGroupCategory";
    currentWidget = makeEditGroupCategoryWidget(groupCategoryId);
  }

  @override
  void updateCurrentWidget() {
    editGroupCategoryViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeEditGroupCategoryWidget(String groupCategoryId) {
    void doneSaveEdit() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void doneDeleteGroupCategory() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void showAlertWarningEdit() {
      this.showAlertWarningEdit(
          editGroupCategoryViewModel!.doUpdateGroupCategory);
    }

    void showAlertWarningDelete() {
      this.showAlertWarningDelete(
          editGroupCategoryViewModel!.doDeleteSpendCategory);
    }

    void navigationPop() {
      pop();
    }

    void showEditGroupMonthMoney(String groupMonthId) {
      EditGroupMonthMoneyCoordinator editGroupMonthMoneyCoordinator =
          EditGroupMonthMoneyCoordinator(
              superCoordinator: this,
              parentTabCoordinator: this,
              groupMonthId: groupMonthId);
      editGroupMonthMoneyCoordinator.start();
    }

    EditGroupCategoryActions actions = EditGroupCategoryActions(
        doneSaveEdit: doneSaveEdit,
        doneDeleteGroupCategory: doneDeleteGroupCategory,
        showAlertWarningEdit: showAlertWarningEdit,
        showAlertWarningDelete: showAlertWarningDelete,
        showEditGroupMonthMoney: showEditGroupMonthMoney,
        navigationPop: navigationPop);

    editGroupCategoryViewModel = appDIContainer.settings
        .makeEditGroupCategoryViewModel(actions, groupCategoryId);

    return appDIContainer.settings
        .makeEditGroupCategoryWidget(editGroupCategoryViewModel!);
  }

  void showAlertWarningEdit(Function() doneSaveEdit) {
    showCupertinoDialog<void>(
      context: NavigationService.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          '해당 소비그룹의 이름이 모두 변경됩니다.',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () async {
              NavigationService.navigatorKey.currentState?.pop();
            },
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              NavigationService.navigatorKey.currentState?.pop();
              doneSaveEdit();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void showAlertWarningDelete(Function() doneDeleteSpendCategory) {
    showCupertinoDialog<void>(
      context: NavigationService.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          '해당 소비그룹으로 지출된 목록들이 모두 삭제됩니다!',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () async {
              NavigationService.navigatorKey.currentState?.pop();
            },
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              NavigationService.navigatorKey.currentState?.pop();
              doneDeleteSpendCategory();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
