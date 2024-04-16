import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import 'AddSpend/ViewModel/AddSpendViewModel.dart';

class AddSpendCoordinator extends Coordinator {
  AddSpendViewModel? addSpendViewModel;

  AddSpendCoordinator(Coordinator? superCoordinator, DateTime date)
      : super(superCoordinator) {
    currentWidget = makeAddSpendWidget(date);
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

  Widget makeAddSpendWidget(DateTime date) {
    void showDatePicker(DateTime date) {
      showDateTimePicker(date);
    }

    void updateCurrentContextWidget() {
      superCoordinator?.updateCurrentWidget();
      pop();
    }

    AddSpendActions actions = AddSpendActions(
      showDatePicker,
      updateCurrentContextWidget,
    );

    addSpendViewModel =
        appDIContainer.addSpend.makeAddSpendViewModel(date, actions);
    return appDIContainer.addSpend.makeAddSpendWidget(addSpendViewModel!);
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
              addSpendViewModel?.didChangeDate(newDate);
            },
          ),
        );
      },
    );
  }
}
