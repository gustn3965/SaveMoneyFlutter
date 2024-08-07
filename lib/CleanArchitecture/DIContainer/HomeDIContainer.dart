import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/AdMob/ViewModel/AdMobBannerViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/AdMob/Widget/AdMobBannerWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DaySpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DefaultDaySpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/Widget/DaySpendListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/LeftMonthFloatingButton/ViewModel/LeftMonthFloatingButtonViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/LeftMonthFloatingButton/Widget/LeftMonthFloatingButtonWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/MonthSpendList/ViewModel/DefaultMonthSpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/MonthSpendList/ViewModel/MonthSpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/MonthSpendList/Widget/MonthSpendListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/DefaultSpendCategorySelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/SpendCategorySelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/Widget/SpendCategorySelectorWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AdMobIdFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendListUseCase.dart';

import '../../main.dart';
import '../Presenter/Home/AddSpendFloatingButton/ViewModel/AddSpendFloatingButtonViewModel.dart';
import '../Presenter/Home/AddSpendFloatingButton/Widget/AddSpendFloatingButtonWidget.dart';
import '../Presenter/Home/Calendar/ViewModel/DefaultGroupMonthCalendarViewModel.dart';
import '../Presenter/Home/Calendar/ViewModel/GroupMonthCalendarViewModel.dart';
import '../Presenter/Home/Calendar/Widget/GroupMonthCalendarWidget.dart';
import '../Presenter/Home/GroupMonthSelector/ViewModel/DefaultGroupMonthSelectorViewModel.dart';
import '../Presenter/Home/GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import '../Presenter/Home/GroupMonthSelector/Widget/GroupMonthSelectorWidget.dart';
import '../Presenter/Home/GroupMonthSummary/ViewModel/DefaultGroupMonthSummaryViewModel.dart';
import '../Presenter/Home/GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';
import '../Presenter/Home/GroupMonthSummary/Widget/GroupMonthSummaryWidget.dart';
import '../Presenter/Home/RightMonthFloatingButton/ViewModel/RightMonthFloatingButtonViewModel.dart';
import '../Presenter/Home/RightMonthFloatingButton/Widget/RightMonthFloatingButtonWidget.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import 'AppDIContainer.dart';

class HomeDIContainer {
  AppStatus appStatus;

  HomeDIContainer(this.appStatus);

  // Main - Summary
  GroupMonthSummaryViewModel makeMainSummaryViewModel() {
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }

    GroupMonthSummaryViewModel summaryViewModel =
        DefaultGroupMonthSummaryViewModel(groupMonthFetchUseCase);
    return summaryViewModel;
  }

  Widget makeMainSummaryWidget(GroupMonthSummaryViewModel viewModel) {
    return GroupMonthSummaryWidget(viewModel: viewModel);
  }

  // Main - GroupMonthSelector
  GroupMonthSelectorViewModel makeMainGroupMonthSelectorViewModel(
      GroupMonthSelectorActions action) {
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }

    GroupMonthSelectorViewModel viewModel =
        DefaultGroupMonthSelectorViewModel(groupMonthFetchUseCase, action);
    return viewModel;
  }

  Widget makeMainGroupMonthSelectorWidget(
      GroupMonthSelectorViewModel viewModel) {
    return GroupMonthSelectorWidget(viewModel: viewModel);
  }

  // Main - SpendCategorySelector
  SpendCategorySelectorViewModel makeMainSpendCategorySelectorViewModel(
      SpendCategorySelectorActions action) {
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }
    SpendCategorySelectorViewModel viewModel =
        DefaultSpendCategorySelectorViewModel(groupMonthFetchUseCase, action);
    return viewModel;
  }

  Widget makeMainSpendCategorySelectorWidget(
      SpendCategorySelectorViewModel viewModel) {
    return SpendCategorySelectorWidget(viewModel: viewModel);
  }

  // Main - Calendar
  GroupMonthCalendarViewModel makeMainGroupMonthCalendarViewModel(
      GroupMonthCalendarActions action) {
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }
    GroupMonthCalendarViewModel viewModel =
        DefaultGroupMonthCalendarViewModel(groupMonthFetchUseCase, action);
    return viewModel;
  }

  Widget makeMainGroupMonthCalendarWidget(
      GroupMonthCalendarViewModel viewModel) {
    return GroupMonthCalendarWidget(viewModel: viewModel);
  }

// Main - AddSpendFloatting
  AddSpendFloatingButtonViewModel makeMainAddSpendFloatingViewModel(
      AddSpendFloatingButtonActions action) {
    AddSpendFloatingButtonViewModel viewModel =
        DefaultAddSpendFloatingButtonViewModel(action);
    return viewModel;
  }

  Widget makeMainAddSpendFloatingWidget(
      AddSpendFloatingButtonViewModel viewModel) {
    return AddSpendFloatingButtonWidget(
      viewModel: viewModel,
    );
  }

  LeftMonthFloatingButtonViewModel makeLeftMonthFloatingViewModel(
      DateTime date, LeftMonthFloatingButtonActions actions) {
    return DefaultLeftMonthFloatingButtonViewModel(date, actions);
  }

  Widget makeLeftMonthFloatingWidget(
      LeftMonthFloatingButtonViewModel viewModel) {
    return LeftMonthFloatingButtonWidget(viewModel: viewModel);
  }

  RightMonthFloatingButtonViewModel makeRightMonthFloatingViewModel(
      DateTime date, RightMonthFloatingButtonActions actions) {
    return DefaultRightMonthFloatingButtonViewModel(date, actions);
  }

  Widget makeRightMonthFloatingWidget(
      RightMonthFloatingButtonViewModel viewModel) {
    return RightMonthFloatingButtonWidget(viewModel: viewModel);
  }

  // Home - DaySpendList

  DaySpendListViewModel makeDaySpendListViewModel(
      DaySpendListAction action, DateTime date, List<String> groupIds) {
    SpendListUseCase spendListUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        spendListUseCase = RepoSpendListUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendListUseCase = MockSpendListUseCase();
        break;
    }

    DaySpendListViewModel viewModel =
        DefaultDaySpendListViewModel(action, date, groupIds, spendListUseCase);
    return viewModel;
  }

  Widget makeDaySpendListWidget(DaySpendListViewModel viewModel) {
    return DaySpendListWidget(viewModel);
  }

  // Home - MonthSpendList

  MonthSpendListViewModel makeMonthSpendListViewModel(
      MonthSpendListAction action, List<String> groupIds) {
    SpendListUseCase spendListUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        spendListUseCase = RepoSpendListUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendListUseCase = MockSpendListUseCase();
        break;
    }

    MonthSpendListViewModel viewModel =
        DefaultMonthSpendListViewModel(action, groupIds, spendListUseCase);
    return viewModel;
  }

  Widget makeMonthSpendListWidget(
      MonthSpendListViewModel viewModel) {
    return MonthSpendListWidget(viewModel);
  }

  AdMobBannerViewModel makeAdMobBannerViewModel(AdMobBannerViewModelAction action) {
    AdMobIdFetchUseCase adMobIdFetchUseCase;

    switch (appStatus) {
      case AppStatus.real:
        adMobIdFetchUseCase = RealAdMobIdFetchUseCase();
      // adMobIdFetchUseCase = NullAdMobIdFetchUseCase();
        break;
      case AppStatus.mock || AppStatus.cbt :
        adMobIdFetchUseCase = TestAdMobIdFetchUseCase();
        break;
    }

    return AdMobBannerViewModel(action, adMobIdFetchUseCase);
  }

  Widget makeAdMobBannerWidget(AdMobBannerViewModel viewModel) {
    return AdMobBannerWidget(viewModel);
  }
}
