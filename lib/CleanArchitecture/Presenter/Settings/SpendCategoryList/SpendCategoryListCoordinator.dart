import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpendCategory/AddSpendCategoryCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';

import '../../../../main.dart';
import '../../AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';

class SpendCategoryListCoordinator extends Coordinator {
  SpendCategoryListViewModel? spendCategoryListViewModel;

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
      AddSpendCategoryCoordinator addSpendCategoryCoordinator =
          AddSpendCategoryCoordinator(this);
      addSpendCategoryCoordinator.startFromModalBottomSheet();
    }

    SpendCategoryListAction action = SpendCategoryListAction(
        showEditSpendCategoryWidget: showEditSpendCategory,
        showAddSpendCategoryWidget: showAddSpendCategory);

    spendCategoryListViewModel =
        appDIContainer.settings.makeSpendCategoryListViewModel(action);

    return appDIContainer.settings
        .makeSpendCategoryListWidget(spendCategoryListViewModel!);
  }
}
