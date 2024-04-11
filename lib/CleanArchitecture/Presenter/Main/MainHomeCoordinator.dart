import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/AddSpendFloatingButton/ViewModel/AddSpendFloatingButtonViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/AddSpendFloatingButton/Widget/AddSpendFloatingButtonWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/Calendar/ViewModel/DefaultGroupMonthCalendarViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/Calendar/ViewModel/GroupMonthCalendarViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/ViewModel/DefaultGroupMonthSelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/Widget/GroupMonthSelectorWidget.dart';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSummary/ViewModel/DefaultGroupMonthSummaryViewModel.dart';
import '../../Domain/Entity/GroupMonth.dart';
import '../../UseCase/GroupMonthFetchUseCase.dart';
import '../AppCoordinator.dart';

import 'Calendar/Widget/GroupMonthCalendarWidget.dart';
import 'GroupMonthSummary/Widget/GroupMonthSummaryWidget.dart';
import 'MainHomeWidget.dart';

class MainHomeCoordinator extends Coordinator {
  @override
  String mainPageName = "/MainHome";

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
        settings: RouteSettings(name: mainPageName),
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
    summaryViewModel =
        DefaultGroupMonthSummaryViewModel(MockGroupMoonthFetchUseCase());
    return GroupMonthSummaryWidget(viewModel: summaryViewModel!);
  }

  Widget makeSelectorWidget() {
    void updateSelectedGroupMonth(GroupMonth? groupMonth) {
      summaryViewModel?.fetchGroupMonth(groupMonth?.identity);
      calendarViewModel?.fetchGroupMonth(groupMonth?.identity);
    }

    void showAddGroup() {
      showAddGroupWidget(calendarViewModel?.focuseDate ?? DateTime.now());
    }

    GroupMonthSelectorActions actions = GroupMonthSelectorActions(
      updateSelectedGroupMonth,
      showAddGroup,
    );

    selectorViewModel = DefaultGroupMonthSelectorViewModel(
        MockGroupMoonthFetchUseCase(), actions);

    return GroupMonthSelectorWidget(viewModel: selectorViewModel!);
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

    calendarViewModel = DefaultGroupMonthCalendarViewModel(
        MockGroupMoonthFetchUseCase(), actions);
    return GroupMonthCalendarWidget(viewModel: calendarViewModel!);
  }

  Widget makeAddSpendFloatingButtonWidget() {
    void showAddSpend() {
      showAddSpendView(calendarViewModel?.selectedDate ?? DateTime.now());
    }

    AddSpendFloatingButtonActions actions = AddSpendFloatingButtonActions(
      showAddSpend,
    );

    addSpendFloatingButtonViewModel =
        DefaultAddSpendFloatingButtonViewModel(actions);
    AddSpendFloatingButtonWidget widget = AddSpendFloatingButtonWidget(
        viewModel: addSpendFloatingButtonViewModel!);
    return widget;
  }

  void showAddSpendView(DateTime date) {
    AddSpendCoordinator spendCoordinator = AddSpendCoordinator();
    spendCoordinator.superCoordinator = this;
    spendCoordinator.startFromModalBottomSheet(date);
    childCoordinator.add(spendCoordinator);
  }

  void showAddGroupWidget(DateTime date) {
    AddGroupCoordinator addGroupCoordinator = AddGroupCoordinator();
    addGroupCoordinator.superCoordinator = this;
    addGroupCoordinator.startFromDate(date);
    childCoordinator.add(addGroupCoordinator);
  }

  void updateCalendarView() {}
}
