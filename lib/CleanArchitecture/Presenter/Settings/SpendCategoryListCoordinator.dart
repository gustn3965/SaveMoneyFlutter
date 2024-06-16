import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpendCategory/AddSpendCategoryCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';

import '../../../main.dart';
import '../AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';
import 'EditSpendCategoryCoordinator.dart';

class SpendCategoryListCoordinator extends Coordinator {
  SpendCategoryListViewModel? spendCategoryListViewModel;

  SpendCategoryListCoordinator(
      {required Coordinator superCoordinator,
      required Coordinator parentTabCoordinator})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "SpendCategoryList";
    currentWidget = makeSpendCategoryListWidget();
  }

  @override
  void updateCurrentWidget() {
    spendCategoryListViewModel?.reloadData();
  }

  Widget makeSpendCategoryListWidget() {
    void showEditSpendCategory(String spendCategoryId) {
      EditSpendCategoryCoordinator editSpendCategoryCoordinator =
          EditSpendCategoryCoordinator(
              superCoordinator: this,
              parentTabCoordinator: this,
              spendCategoryId: spendCategoryId);
      editSpendCategoryCoordinator.start();
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
