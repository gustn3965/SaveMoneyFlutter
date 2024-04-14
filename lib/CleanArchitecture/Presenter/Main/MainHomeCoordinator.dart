import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/AddSpendFloatingButton/ViewModel/AddSpendFloatingButtonViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/Calendar/ViewModel/GroupMonthCalendarViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';

import 'package:save_money_flutter/main.dart';
import '../../Domain/Entity/GroupMonth.dart';
import '../AppCoordinator.dart';

import 'MainHomeWidget.dart';

class MainHomeCoordinator extends Coordinator {
  @override
  String routeName = "Root";

  GroupMonthSummaryViewModel? summaryViewModel;
  GroupMonthSelectorViewModel? selectorViewModel;
  GroupMonthCalendarViewModel? calendarViewModel;
  AddSpendFloatingButtonViewModel? addSpendFloatingButtonViewModel;

  @override
  void start() {
    Widget selectorWidget = makeSelectorWidget();
    Widget summaryWidget = makeSummaryWidget();
    Widget calendarWidget = makeCalendarWidget();

    Widget addSpendFloattingWidget = makeAddSpendFloatingButtonWidget();

    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => MainHomeWidget(
          widgets: [summaryWidget, selectorWidget, calendarWidget],
          floattingButtons: [addSpendFloattingWidget],
        ),
      ),
    );
  }

  @override
  void pop() {
    Navigator.pop(NavigationService.currentContext!);
    superCoordinator?.childCoordinator.remove(this);
  }

  @override
  void startFromModalBottomSheet() {}

  @override
  void updateCurrentWidget() {
    selectorViewModel?.reloadFetch();
    summaryViewModel?.reloadFetch();
    calendarViewModel?.reloadFetch();
    print('MainHomeCoordinator updateCurrentWidget....');
  }

  Widget makeSummaryWidget() {
    summaryViewModel = appDIContainer.main.makeMainSummaryViewModel();
    return appDIContainer.main.makeMainSummaryWidget(summaryViewModel!);
  }

  Widget makeSelectorWidget() {
    void updateSelectedGroupMonth(GroupMonth? groupMonth) {
      summaryViewModel?.fetchGroupMonth(groupMonth?.identity);
      calendarViewModel?.fetchGroupMonth(groupMonth?.identity);
    }

    void showAddGroup() {
      showAddGroupView(calendarViewModel?.focuseDate ?? DateTime.now());
    }

    GroupMonthSelectorActions actions = GroupMonthSelectorActions(
      updateSelectedGroupMonth,
      showAddGroup,
    );

    selectorViewModel =
        appDIContainer.main.makeMainGroupMonthSelectorViewModel(actions);

    return appDIContainer.main
        .makeMainGroupMonthSelectorWidget(selectorViewModel!);
  }

  Widget makeCalendarWidget() {
    void updateFocusDateTime(DateTime date) {
      selectorViewModel?.fetchGroupMonthList(date);
    }

    void updateSelectedDateTime(DateTime date) {
      print('Updating selected date time: $date');
    }

    GroupMonthCalendarActions actions = GroupMonthCalendarActions(
      updateFocusDateTime,
      updateSelectedDateTime,
    );

    calendarViewModel =
        appDIContainer.main.makeMainGroupMonthCalendarViewModel(actions);
    return appDIContainer.main
        .makeMainGroupMonthCalendarWidget(calendarViewModel!);
  }

  Widget makeAddSpendFloatingButtonWidget() {
    void showAddSpend() {
      showAddSpendView(calendarViewModel?.selectedDate ?? DateTime.now());
    }

    AddSpendFloatingButtonActions actions = AddSpendFloatingButtonActions(
      showAddSpend,
    );

    addSpendFloatingButtonViewModel =
        appDIContainer.main.makeMainAddSpendFloatingViewModel(actions);
    return appDIContainer.main
        .makeMainAddSpendFloatingWidget(addSpendFloatingButtonViewModel!);
  }

  void showAddSpendView(DateTime date) {
    bool isModal = true;
    coordinator.showAddSpendView(this, isModal, date);
  }

  void showAddGroupView(DateTime date) {
    coordinator.showAddGroupMonthView(this, date);
  }

  void updateCalendarView() {}
}
