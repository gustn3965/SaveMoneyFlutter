import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/EditSpend/EditSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DaySpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/SpendCategorySelectorViewModel.dart';

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
  GroupMonthSelectorViewModel? groupSelectorViewModel;
  SpendCategorySelectorViewModel? spendCategorySelectorViewModel;
  GroupMonthCalendarViewModel? calendarViewModel;
  DaySpendListViewModel? daySpendListViewModel;
  AddSpendFloatingButtonViewModel? addSpendFloatingButtonViewModel;

  HomeCoordinator(Coordinator? superCoordinator) : super(superCoordinator) {
    routeName =
        "Home"; // MainHome에서 호출할경우 routeName은 MainHome으로. ( Navigation push를 안함 )
    Widget summaryWidget = makeSummaryWidget();
    Widget groupSelectorWidget = makeGroupSelectorWidget();
    Widget spendCategorySelectorWidget = makeSpendCategorySelectorWidget();
    Widget calendarWidget = makeCalendarWidget();
    Widget daysSpendListWidget = makeDaySpendListWidget();

    Widget addSpendFloattingWidget = makeAddSpendFloatingButtonWidget();
    Widget spacingView = SizedBox(height: 50);

    currentWidget = HomeWidget(
      widgets: [
        summaryWidget,
        groupSelectorWidget,
        spendCategorySelectorWidget,
        calendarWidget,
        daysSpendListWidget,
        spacingView
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
    groupSelectorViewModel?.reloadFetch();
    summaryViewModel?.reloadFetch();
    calendarViewModel?.reloadFetch();
    daySpendListViewModel?.reloadFetch();

    print('HomeCoordinator updateCurrentWidget....');
  }

  Widget makeSummaryWidget() {
    summaryViewModel = appDIContainer.home.makeMainSummaryViewModel();
    return appDIContainer.home.makeMainSummaryWidget(summaryViewModel!);
  }

  Widget makeGroupSelectorWidget() {
    void updateSelectedGroupMonth(List<String> updateSelectedGroupIds) {
      summaryViewModel?.fetchGroupMonths(updateSelectedGroupIds);
      spendCategorySelectorViewModel
          ?.fetchGroupMonthsIds(updateSelectedGroupIds);
      calendarViewModel?.fetchGroupMonths(updateSelectedGroupIds);
      daySpendListViewModel?.groupIds = updateSelectedGroupIds;
      daySpendListViewModel?.reloadFetch();
    }

    void showAddGroup() {
      showAddGroupView(calendarViewModel?.focuseDate ?? DateTime.now());
    }

    GroupMonthSelectorActions actions = GroupMonthSelectorActions(
      updateSelectedGroupMonth,
      showAddGroup,
    );

    groupSelectorViewModel =
        appDIContainer.home.makeMainGroupMonthSelectorViewModel(actions);

    return appDIContainer.home
        .makeMainGroupMonthSelectorWidget(groupSelectorViewModel!);
  }

  Widget makeSpendCategorySelectorWidget() {
    void updateSelectedCategory(List<String> selectedSpendCategory) {
      summaryViewModel
          ?.fetchGroupMonthWithSpendCategories(selectedSpendCategory);
      calendarViewModel
          ?.fetchGroupMonthWithSpendCategories(selectedSpendCategory);
      daySpendListViewModel?.spendCategories = selectedSpendCategory;
      daySpendListViewModel?.reloadFetch();
    }

    SpendCategorySelectorActions actions = SpendCategorySelectorActions(
      updateSelectedCategory,
    );

    spendCategorySelectorViewModel =
        appDIContainer.home.makeMainSpendCategorySelectorViewModel(actions);

    return appDIContainer.home
        .makeMainSpendCategorySelectorWidget(spendCategorySelectorViewModel!);
  }

  Widget makeCalendarWidget() {
    void updateFocusDateTime(DateTime date) {
      groupSelectorViewModel?.fetchGroupMonthList(date);
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
    void showModifySpendItem(String spendId) {
      showEditSpendView(spendId);
    }

    DaySpendListAction action = DaySpendListAction(showModifySpendItem);

    daySpendListViewModel = appDIContainer.home
        .makeDaySpendListViewModel(action, DateTime.now(), []);
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

  void showEditSpendView(String spendId) {
    EditSpendCoordinator editSpendCoordinator =
        EditSpendCoordinator(this, spendId);
    editSpendCoordinator.startFromModalBottomSheet();
  }

  void updateCalendarView() {}
}
