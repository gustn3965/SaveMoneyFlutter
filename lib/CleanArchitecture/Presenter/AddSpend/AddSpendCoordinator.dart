import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpendCategory/AddSpendCategoryCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import '../../../AppColor/AppColors.dart';
import 'AddSpend/ViewModel/AddSpendViewModel.dart';

class AddSpendCoordinator extends Coordinator {
  AddSpendViewModel? addSpendViewModel;

  AddSpendCoordinator(
      Coordinator? superCoordinator, DateTime date, GroupMonth? groupMonth)
      : super(superCoordinator, null) {
    routeName = "addSpend";
    currentWidget = makeAddSpendWidget(date, groupMonth);
  }

  @override
  void updateCurrentWidget() {
    addSpendViewModel?.fetchSpendCategoryList();
  }

  Widget makeAddSpendWidget(DateTime date, GroupMonth? selectedGroupMonth) {
    void showDatePicker(DateTime date) {
      showDateTimePicker(date);
    }

    void didAddSpend() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void clickAddSpendCategory() {
      showAddSpendCategoryView();
    }

    AddSpendActions actions = AddSpendActions(
      showDatePicker,
      didAddSpend,
      clickAddSpendCategory,
    );

    addSpendViewModel = appDIContainer.addSpend
        .makeAddSpendViewModel(date, selectedGroupMonth, actions);
    return appDIContainer.addSpend.makeAddSpendWidget(addSpendViewModel!);
  }

  void showAddSpendCategoryView() {
    AddSpendCategoryCoordinator addSpendCategoryCoordinator =
        AddSpendCategoryCoordinator(this);
    addSpendCategoryCoordinator.startFromModalBottomSheet();
  }

  void showDateTimePicker(DateTime date) {
    showCupertinoModalPopup(
      context: NavigationService.navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: appColors.whiteColor(),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: date,
            onDateTimeChanged: (DateTime newDate) async {
              addSpendViewModel?.didChangeDate(newDate);
            },
          ),
        );
      },
    );
  }
}
