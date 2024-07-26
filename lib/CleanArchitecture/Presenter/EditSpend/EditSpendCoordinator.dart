import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import '../../../AppColor/AppColors.dart';
import '../AddSpendCategory/AddSpendCategoryCoordinator.dart';
import 'ViewModel/EditSpendViewModel.dart';

class EditSpendCoordinator extends Coordinator {
  EditSpendViewModel? editSpendViewModel;

  EditSpendCoordinator(Coordinator? superCoordinator, String spendId)
      : super(superCoordinator, null) {
    routeName = "EditSpend";
    currentWidget = makeEditSpendWidget(spendId);
  }

  @override
  void updateCurrentWidget() {
    editSpendViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeEditSpendWidget(String spendId) {
    void showDatePicker(DateTime date) {
      showDateTimePicker(date);
    }

    void didEditSpend() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void didDeleteSpend() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    void showAddSpendCategoryView() {
      AddSpendCategoryCoordinator addSpendCategoryCoordinator =
          AddSpendCategoryCoordinator(this);
      addSpendCategoryCoordinator.startFromModalBottomSheet();
    }

    void showEmptyContentWarning(String description) {
      showAlertEmptyContent(description);
    }

    EditSpendActions actions = EditSpendActions(
      showDatePicker,
      didEditSpend,
      didDeleteSpend,
      showAddSpendCategoryView,
      showEmptyContentWarning,
    );

    editSpendViewModel =
        appDIContainer.editSpend.makeEditSpendViewModel(spendId, actions);
    return appDIContainer.editSpend.makeEditSpendWidget(editSpendViewModel!);
  }

  void showDateTimePicker(DateTime date) {
    showCupertinoModalPopup(
      context: NavigationService.navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: appColors.constWhiteColor(),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: date,
            onDateTimeChanged: (DateTime newDate) async {
              editSpendViewModel?.didChangeDate(newDate);
            },
          ),
        );
      },
    );
  }

  void showAlertEmptyContent(String description) {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('필수정보 부족'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
