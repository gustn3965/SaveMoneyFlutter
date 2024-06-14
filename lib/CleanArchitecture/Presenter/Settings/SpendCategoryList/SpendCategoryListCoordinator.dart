import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';

import '../../../../main.dart';
import '../../AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';

class SpendCategoryListCoordinator extends Coordinator {
  SpendCategoryListViewModel? spendCategoryListViewModel;
  AddSpendCategoryViewModel? addSpendCategoryViewModel;

  Widget? addSpendCategoryWidget;

  SpendCategoryListCoordinator(Coordinator superCoordinator)
      : super(superCoordinator) {
    routeName = "SpendCategoryList";
    currentWidget = makeSpendCategoryListWidget();
  }

  @override
  void start() {
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => currentWidget,
      ),
    );
  }

  @override
  void updateCurrentWidget() {
    spendCategoryListViewModel?.reloadData();
  }

  Widget makeSpendCategoryListWidget() {
    void showEditSpendCategory(String spendCategoryId) {
      print("edit.... 미구현 ");

      // TODO: implement updateCurrentWidget
    }

    void showAddSpendCategory() {
      showAddSpendCategoryFromModalBottomSheet();
    }

    SpendCategoryListAction action = SpendCategoryListAction(
        showEditSpendCategoryWidget: showEditSpendCategory,
        showAddSpendCategoryWidget: showAddSpendCategory);

    spendCategoryListViewModel =
        appDIContainer.settings.makeSpendCategoryListViewModel(action);

    return appDIContainer.settings
        .makeSpendCategoryListWidget(spendCategoryListViewModel!);
  }

  void showAddSpendCategoryFromModalBottomSheet() {
    addSpendCategoryWidget = makeAddSpendCategoryWidget();

    showModalBottomSheet(
      context: NavigationService.currentContext!,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: addSpendCategoryWidget!);
      },
    );
  }

  Widget makeAddSpendCategoryWidget() {
    void didAddSpendCategory() {
      updateCurrentWidget();
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

    addSpendCategoryViewModel =
        appDIContainer.addSpendCategory.makeAddSpendCategoryViewModel(actions);

    return appDIContainer.addSpendCategory
        .makeAddSpendCategoryWidget(addSpendCategoryViewModel!);
  }

  void popFromBottomSheet() {
    Navigator.pop(NavigationService.currentContext!);
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
