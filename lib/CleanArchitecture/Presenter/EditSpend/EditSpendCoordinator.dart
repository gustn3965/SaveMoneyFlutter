import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import 'ViewModel/EditSpendViewModel.dart';

class EditSpendCoordinator extends Coordinator {
  EditSpendViewModel? editSpendViewModel;

  EditSpendCoordinator(Coordinator? superCoordinator, String spendId)
      : super(superCoordinator, null) {
    routeName = "EditSpend";
    currentWidget = makeEditSpendWidget(spendId);
  }

  @override
  void updateCurrentWidget() {}

  Widget makeEditSpendWidget(String spendId) {
    void showDatePicker(DateTime date) {
      showDateTimePicker(date);
    }

    void didEditSpend() {
      superCoordinator?.updateCurrentWidget();
      pop();
    }

    void didDeleteSpend() {
      superCoordinator?.updateCurrentWidget();
      triggerTopUpdateWidget();
      pop();
    }

    EditSpendActions actions = EditSpendActions(
      showDatePicker,
      didEditSpend,
      didDeleteSpend,
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
          color: Colors.white,
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
}
