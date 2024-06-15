import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/main.dart';

import '../AppCoordinator.dart';
import 'AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';

class AddSpendCategoryCoordinator extends Coordinator {
  AddSpendCategoryViewModel? addSpendViewModel;

  AddSpendCategoryCoordinator(Coordinator? superCoordinator)
      : super(superCoordinator, null) {
    routeName = "addSpendCategory";
    currentWidget = makeAddSpendCategoryWidget();
  }

  @override
  void start() {
    super.start();
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  void popFromBottomSheet() {
    Navigator.pop(NavigationService.navigatorKey.currentContext!);
  }

  void updateSuperCoordinatorWidget() {
    superCoordinator?.updateCurrentWidget();
  }

  Widget makeAddSpendCategoryWidget() {
    void didAddSpendCategory() {
      updateSuperCoordinatorWidget();
      popFromBottomSheet();
    }

    void didClickCancel() {
      popFromBottomSheet();
    }

    void showAlertHasAlreadySameCategory() {
      showHasAlreadyCategoryNameAlert();
    }

    AddSpendCategoryActions actions = AddSpendCategoryActions(
        didAddSpendCategory, didClickCancel, showAlertHasAlreadySameCategory);

    addSpendViewModel =
        appDIContainer.addSpendCategory.makeAddSpendCategoryViewModel(actions);

    return appDIContainer.addSpendCategory
        .makeAddSpendCategoryWidget(addSpendViewModel!);
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
