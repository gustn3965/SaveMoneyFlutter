import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/EditSpend/EditSpendCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/AdMob/ViewModel/AdMobBannerViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DaySpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/HomeViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/LeftMonthFloatingButton/Widget/LeftMonthFloatingButtonWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/MonthSpendList/ViewModel/MonthSpendListViewModel.dart';
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
import 'LeftMonthFloatingButton/ViewModel/LeftMonthFloatingButtonViewModel.dart';
import 'RightMonthFloatingButton/ViewModel/RightMonthFloatingButtonViewModel.dart';

class HomeCoordinator extends Coordinator {

  HomeViewModel homeBaseViewModel = HomeViewModel();

  GroupMonthSummaryViewModel? summaryViewModel;
  GroupMonthSelectorViewModel? groupSelectorViewModel;
  SpendCategorySelectorViewModel? spendCategorySelectorViewModel;
  GroupMonthCalendarViewModel? calendarViewModel;
  DaySpendListViewModel? daySpendListViewModel;
  MonthSpendListViewModel? monthSpendListViewModel;
  AdMobBannerViewModel? adMobBannerViewModel;

  AddSpendFloatingButtonViewModel? addSpendFloatingButtonViewModel;
  LeftMonthFloatingButtonViewModel? leftMonthFloatingButtonViewModel;
  RightMonthFloatingButtonViewModel? rightMonthFloatingButtonViewModel;


  HomeCoordinator(Coordinator? superCoordinator)
      : super(superCoordinator, null) {
    routeName =
        "Home"; // MainHome에서 호출할경우 routeName은 MainHome으로. ( Navigation push를 안함 )
    Widget summaryWidget = makeSummaryWidget();
    Widget groupSelectorWidget = makeGroupSelectorWidget();
    Widget spendCategorySelectorWidget = makeSpendCategorySelectorWidget();
    Widget calendarWidget = makeCalendarWidget();
    Widget daysSpendListWidget = makeDaySpendListWidget();
    Widget monthSpendListWidget = makeMonthSpendListWidget();
    Widget adMobBannerWidget = makeAdMobBannerWidget();

    Widget addSpendFloattingWidget = makeAddSpendFloatingButtonWidget();
    Widget moveLeftFloattingWidget = makeLeftMonthFloatingButtonWidget();
    Widget moveRightFloattingWidget = makeRightMonthFloatingButtonWidget();

    Widget spacingView = SizedBox(height: 50);

    currentWidget = HomeWidget(
      viewModel: homeBaseViewModel,
      widgets: [
        summaryWidget,
        groupSelectorWidget,
        spendCategorySelectorWidget,
        calendarWidget,
        daysSpendListWidget,
        monthSpendListWidget,
        spacingView
      ],
      fixedBottomWidgets: [
        adMobBannerWidget,
      ],
      floattingButtons: [moveLeftFloattingWidget, moveRightFloattingWidget, addSpendFloattingWidget],
    );
  }

  // 띄운화면을 닫을때 부모위젯을 업데이트하고자할때.
  @override
  void updateCurrentWidget() {
    homeBaseViewModel.reloadData();

    groupSelectorViewModel?.reloadFetch();
    summaryViewModel?.reloadFetch();
    calendarViewModel?.reloadFetch();
    daySpendListViewModel?.reloadFetch();
    monthSpendListViewModel?.reloadFetch();

    leftMonthFloatingButtonViewModel?.reloadData();
    rightMonthFloatingButtonViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }

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
      monthSpendListViewModel?.groupIds = updateSelectedGroupIds;
      monthSpendListViewModel?.reloadFetch();
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
      monthSpendListViewModel?.spendCategories = selectedSpendCategory;
      monthSpendListViewModel?.reloadFetch();
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

      daySpendListViewModel?.date = date;
      daySpendListViewModel?.reloadFetch();
    }

    void updateSelectedDateTime(DateTime date) {
      daySpendListViewModel?.date = date;
      daySpendListViewModel?.reloadFetch();
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
      GroupMonth? selectedGroupMonth =
          groupSelectorViewModel?.selectedGroupMonths.firstOrNull;
      DateTime selectedDate = calendarViewModel?.selectedDate ?? DateTime.now();
      showAddSpendView(
          date: selectedDate, selectedGroupMonth: selectedGroupMonth);
    }

    AddSpendFloatingButtonActions actions = AddSpendFloatingButtonActions(
      showAddSpend,
    );

    addSpendFloatingButtonViewModel =
        appDIContainer.home.makeMainAddSpendFloatingViewModel(actions);
    return appDIContainer.home
        .makeMainAddSpendFloatingWidget(addSpendFloatingButtonViewModel!);
  }

  Widget makeLeftMonthFloatingButtonWidget() {
    void moveLeftMonth(DateTime date) {
      calendarViewModel?.focuseDate = date;
      groupSelectorViewModel?.fetchGroupMonthList(date);
      rightMonthFloatingButtonViewModel?.currentDate = date;
    }

    LeftMonthFloatingButtonActions actions = LeftMonthFloatingButtonActions(
      moveLeftMonth,
    );

    leftMonthFloatingButtonViewModel =
        appDIContainer.home.makeLeftMonthFloatingViewModel(DateTime.now(), actions);
    return appDIContainer.home
        .makeLeftMonthFloatingWidget(leftMonthFloatingButtonViewModel!);
  }

  Widget makeRightMonthFloatingButtonWidget() {
    void moveRightMonth(DateTime date) {
      calendarViewModel?.focuseDate = date;
      groupSelectorViewModel?.fetchGroupMonthList(date);
      leftMonthFloatingButtonViewModel?.currentDate = date;
    }

    RightMonthFloatingButtonActions actions = RightMonthFloatingButtonActions(
      moveRightMonth,
    );

    rightMonthFloatingButtonViewModel =
        appDIContainer.home.makeRightMonthFloatingViewModel(DateTime.now(), actions);
    return appDIContainer.home
        .makeRightMonthFloatingWidget(rightMonthFloatingButtonViewModel!);
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

  Widget makeMonthSpendListWidget() {
    void showModifySpendItem(String spendId) {
      showEditSpendView(spendId);
    }

    MonthSpendListAction action = MonthSpendListAction(showModifySpendItem);

    monthSpendListViewModel = appDIContainer.home.makeMonthSpendListViewModel(action, []);

    return appDIContainer.home.makeMonthSpendListWidget(monthSpendListViewModel!);

  }

  Widget makeAdMobBannerWidget() {
    void didLoadedAdMob(bool didLoadedAdMob) {
      homeBaseViewModel.didChangeLoadedAdMob(didLoadedAdMob);
    }
    AdMobBannerViewModelAction action = AdMobBannerViewModelAction(
        didLoadedAdMob
    );


    adMobBannerViewModel = appDIContainer.home.makeAdMobBannerViewModel(action);

    return appDIContainer.home.makeAdMobBannerWidget(adMobBannerViewModel!);
  }

  void showAddSpendView(
      {required DateTime date, required GroupMonth? selectedGroupMonth}) {
    AddSpendCoordinator addSpendCoordinator =
        AddSpendCoordinator(this, date, selectedGroupMonth);
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
