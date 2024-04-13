import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/ViewModel/DefaultAddSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/Widget/AddSpendWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddSpendUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';

import 'AddSpend/ViewModel/AddSpendViewModel.dart';

class AddSpendCoordinator extends Coordinator {
  AddSpendViewModel? addSpendViewModel;

  @override
  void pop() {
    NavigationService.navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == (superCoordinator?.routeName ?? ""));
    superCoordinator?.childCoordinator.remove(this);
  }

  @override
  void start() {
    TEST();
  }

  @override
  void updateCurrentWidget() {}

  void startFromModalBottomSheet(DateTime date) {
    Widget addSpendWidget = makeAddSpendWidget(date);

    showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: addSpendWidget);
      },
    );
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

    addSpendViewModel = DefaultAddSpendViewModel(
        actions,
        date,
        MockSpendCategoryFetchUseCase(),
        MockGroupCategoryFetchUseCase(),
        MockAddSpendUseCase());
    return AddSpendWidget(addSpendViewModel!);
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

  void TEST() {
    Widget addSpendWidget = makeAddSpendWidget(DateTime.now());
    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => addSpendWidget,
      ),
    );
  }
}
