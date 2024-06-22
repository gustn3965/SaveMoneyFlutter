import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DaySpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DefaultDaySpendListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/Widget/DaySpendListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/DefaultSpendCategorySelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/SpendCategorySelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/Widget/SpendCategorySelectorWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabWidget.dart';
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

  DaySpendListWidget makeDaySpendListWidget(DaySpendListViewModel viewModel) {
    return DaySpendListWidget(viewModel);
  }
}
