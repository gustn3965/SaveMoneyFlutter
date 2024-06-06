import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import 'ViewModel/EditSpendViewModel.dart';

class EditSpendCoordinator extends Coordinator {
  EditSpendViewModel? editSpendViewModel;

  EditSpendCoordinator(Coordinator? superCoordinator, String spendId)
      : super(superCoordinator) {
    currentWidget = makeEditSpendWidget(spendId);
  }

  @override
  void pop() {
    NavigationService.navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == (superCoordinator?.routeName ?? ""));
    superCoordinator?.childCoordinator.remove(this);
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

  @override
  void updateCurrentWidget() {}

  void startFromModalBottomSheet() {
    showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: currentWidget);
      },
    ).whenComplete(() {
      pop();
    });
  }

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
