import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditSpendCategory/ViewModel/EditSpendCategoryViewModel.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';

class EditSpendCategoryCoordinator extends Coordinator {
  EditSpendCategoryViewModel? editSpendCategoryViewModel;

  EditSpendCategoryCoordinator(
      {required Coordinator superCoordinator,
      required Coordinator parentTabCoordinator,
      required String spendCategoryId})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "EditSpendCategory";
    currentWidget = makeEditSpendCategoryWidget(spendCategoryId);
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeEditSpendCategoryWidget(String spendCategoryId) {
    void doneSaveEdit() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void doneDeleteSpendCategory() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void showAlertWarningEdit() {
      this.showAlertWarningEdit(
          editSpendCategoryViewModel!.doUpdateSpendCategory);
    }

    void showAlertSameName() {
      this.showAlertSameName(
          editSpendCategoryViewModel!.doUpdateSpendCategory);
    }

    void showAlertWarningDelete() {
      this.showAlertWarningDelete(
          editSpendCategoryViewModel!.doDeleteSpendCategory);
    }

    void navigationPop() {
      pop();
    }

    EditSpendCategoryActions action = EditSpendCategoryActions(
        doneSaveEdit: doneSaveEdit,
        doneDeleteSpendCategory: doneDeleteSpendCategory,
        showAlertWarningEdit: showAlertWarningEdit,
        showAlertSameName: showAlertSameName,
        showAlertWarningDelete: showAlertWarningDelete,
        navigationPop: navigationPop);

    editSpendCategoryViewModel = appDIContainer.settings
        .makeEditSpendCategoryViewModel(
            action: action, spendCategoryId: spendCategoryId);

    return appDIContainer.settings
        .makeEditSpendCategoryWidget(editSpendCategoryViewModel!);
  }

  void showAlertWarningEdit(Function() doneSaveEdit) {
    showCupertinoDialog<void>(
      context: NavigationService.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          '해당 카테고리로 지출된 소비 카테고리 이름이 모두 바뀌게 됩니다.',
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

  void showAlertSameName(Function() doneSaveEdit) {
    showCupertinoDialog<void>(
      context: NavigationService.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          '변경하고자 하는 이름이 이미 존재합니다. \n변경할경우 "카테고리 이름"이 소비된 내역의 "설명"에 포함됩니다.',
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
          '해당 카테고리로 지출된 목록들이 모두 삭제됩니다.',
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
