import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/main.dart';

import '../AppCoordinator.dart';
import 'AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';

class AddSpendCategoryCoordinator extends Coordinator {
  AddSpendCategoryViewModel? addSpendViewModel;

  AddSpendCategoryCoordinator(Coordinator? superCoordinator)
      : super(superCoordinator) {
    currentWidget = makeAddSpendCategoryWidget();
  }

  @override
  void start() {
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        settings: RouteSettings(name: "/Page1"),
        builder: (context) => currentWidget,
      ),
    );
  }

  void popFromBottomSheet() {
    Navigator.pop(NavigationService.navigatorKey.currentContext!);
  }

  void startFromModalBottomSheet() {
    showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: currentWidget);
      },
    ).whenComplete(() {
      // popFromBottomSheet();
    });
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddSpendCategoryWidget() {
    void didAddSpendCategory() {
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
