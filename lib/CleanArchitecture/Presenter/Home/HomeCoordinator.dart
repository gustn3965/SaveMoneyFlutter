import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DaySpendListViewModel.dart';

import '../../../main.dart';
import '../../Domain/Entity/GroupMonth.dart';
import '../AddGroup/AddGroupCoordinator.dart';
import '../AddSpend/AddSpendCoordinator.dart';
import 'AddSpendFloatingButton/ViewModel/AddSpendFloatingButtonViewModel.dart';
import 'Calendar/ViewModel/GroupMonthCalendarViewModel.dart';
import 'GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import 'GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';
import 'HomeWidget.dart';

class HomeCoordinator extends Coordinator {
  GroupMonthSummaryViewModel? summaryViewModel;
  GroupMonthSelectorViewModel? selectorViewModel;
  GroupMonthCalendarViewModel? calendarViewModel;
  DaySpendListViewModel? daySpendListViewModel;
  AddSpendFloatingButtonViewModel? addSpendFloatingButtonViewModel;

  HomeCoordinator(Coordinator? superCoordinator) : super(superCoordinator) {
    routeName =
        "Home"; // MainHome에서 호출할경우 routeName은 MainHome으로. ( Navigation push를 안함 )
    Widget selectorWidget = makeSelectorWidget();
    Widget summaryWidget = makeSummaryWidget();
    Widget calendarWidget = makeCalendarWidget();
    Widget daysSpendListWidget = makeDaySpendListWidget();

    Widget addSpendFloattingWidget = makeAddSpendFloatingButtonWidget();

    currentWidget = HomeWidget(
      widgets: [
        summaryWidget,
        selectorWidget,
        calendarWidget,
        daysSpendListWidget
      ],
      floattingButtons: [addSpendFloattingWidget],
    );
  }

  @override
  void start() {
    NavigationService.navigatorKey.currentState!.push(
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => currentWidget,
      ),
    );
  }

  @override
  void startFromModalBottomSheet() {}

  // 띄운화면을 닫을때 부모위젯을 업데이트하고자할때.
  @override
  void updateCurrentWidget() {
    selectorViewModel?.reloadFetch();
    summaryViewModel?.reloadFetch();
    calendarViewModel?.reloadFetch();
    daySpendListViewModel?.reloadFetch();

    print('HomeCoordinator updateCurrentWidget....');
  }

  Widget makeSummaryWidget() {
    summaryViewModel = appDIContainer.home.makeMainSummaryViewModel();
    return appDIContainer.home.makeMainSummaryWidget(summaryViewModel!);
  }

  Widget makeSelectorWidget() {
    void updateSelectedGroupMonth(GroupMonth? groupMonth) {
      summaryViewModel?.fetchGroupMonth(groupMonth?.identity);
      calendarViewModel?.fetchGroupMonth(groupMonth?.identity);
      daySpendListViewModel?.groupId = groupMonth?.identity ?? 0;
      daySpendListViewModel?.reloadFetch();
    }

    void showAddGroup() {
      showAddGroupView(calendarViewModel?.focuseDate ?? DateTime.now());
    }

    GroupMonthSelectorActions actions = GroupMonthSelectorActions(
      updateSelectedGroupMonth,
      showAddGroup,
    );

    selectorViewModel =
        appDIContainer.home.makeMainGroupMonthSelectorViewModel(actions);

    return appDIContainer.home
        .makeMainGroupMonthSelectorWidget(selectorViewModel!);
  }

  Widget makeCalendarWidget() {
    void updateFocusDateTime(DateTime date) {
      selectorViewModel?.fetchGroupMonthList(date);
    }

    void updateSelectedDateTime(DateTime date) {
      daySpendListViewModel?.date = date;
      daySpendListViewModel?.reloadFetch();
      print('Updating selected date time: $date');
    }

    GroupMonthCalendarActions actions = GroupMonthCalendarActions(
      updateFocusDateTime,
      updateSelectedDateTime,
    );

    calendarViewModel =
        appDIContainer.home.makeMainGroupMonthCalendarViewModel(actions);
    return appDIContainer.home
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
        appDIContainer.home.makeMainAddSpendFloatingViewModel(actions);
    return appDIContainer.home
        .makeMainAddSpendFloatingWidget(addSpendFloatingButtonViewModel!);
  }

  Widget makeDaySpendListWidget() {
    void showModifySpendItem(int spendId) {}

    DaySpendListAction action = DaySpendListAction(showModifySpendItem);

    daySpendListViewModel = appDIContainer.home
        .makeDaySpendListViewModel(action, DateTime.now(), 0);
    return appDIContainer.home.makeDaySpendListWidget(daySpendListViewModel!);
  }

  void showAddSpendView(DateTime date) {
    AddSpendCoordinator addSpendCoordinator = AddSpendCoordinator(this, date);
    addSpendCoordinator.startFromModalBottomSheet();
  }

  void showAddGroupView(DateTime date) {
    AddGroupCoordinator addGroupCoordinator = AddGroupCoordinator(this, date);
    addGroupCoordinator.start();
  }

  void updateCalendarView() {}
}
