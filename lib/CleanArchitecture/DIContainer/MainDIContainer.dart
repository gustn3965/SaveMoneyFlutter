import 'package:flutter/cupertino.dart';

import '../Presenter/Main/AddSpendFloatingButton/ViewModel/AddSpendFloatingButtonViewModel.dart';
import '../Presenter/Main/AddSpendFloatingButton/Widget/AddSpendFloatingButtonWidget.dart';
import '../Presenter/Main/Calendar/ViewModel/DefaultGroupMonthCalendarViewModel.dart';
import '../Presenter/Main/Calendar/ViewModel/GroupMonthCalendarViewModel.dart';
import '../Presenter/Main/Calendar/Widget/GroupMonthCalendarWidget.dart';
import '../Presenter/Main/GroupMonthSelector/ViewModel/DefaultGroupMonthSelectorViewModel.dart';
import '../Presenter/Main/GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import '../Presenter/Main/GroupMonthSelector/Widget/GroupMonthSelectorWidget.dart';
import '../Presenter/Main/GroupMonthSummary/ViewModel/DefaultGroupMonthSummaryViewModel.dart';
import '../Presenter/Main/GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';
import '../Presenter/Main/GroupMonthSummary/Widget/GroupMonthSummaryWidget.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import 'AppDIContainer.dart';

class MainDIContainer {
  AppStatus appStatus;

  MainDIContainer(this.appStatus);

  // Main - Summary
  GroupMonthSummaryViewModel makeMainSummaryViewModel() {
    GroupMonthSummaryViewModel summaryViewModel =
        DefaultGroupMonthSummaryViewModel(MockGroupMonthFetchUseCase());
    return summaryViewModel;
  }

  Widget makeMainSummaryWidget(GroupMonthSummaryViewModel viewModel) {
    return GroupMonthSummaryWidget(viewModel: viewModel);
  }

  // Main - GroupMonthSelector
  GroupMonthSelectorViewModel makeMainGroupMonthSelectorViewModel(
      GroupMonthSelectorActions action) {
    GroupMonthSelectorViewModel viewModel = DefaultGroupMonthSelectorViewModel(
        MockGroupMonthFetchUseCase(), action);
    return viewModel;
  }

  Widget makeMainGroupMonthSelectorWidget(
      GroupMonthSelectorViewModel viewModel) {
    return GroupMonthSelectorWidget(viewModel: viewModel);
  }

  // Main - Calendar
  GroupMonthCalendarViewModel makeMainGroupMonthCalendarViewModel(
      GroupMonthCalendarActions action) {
    GroupMonthCalendarViewModel viewModel = DefaultGroupMonthCalendarViewModel(
        MockGroupMonthFetchUseCase(), action);
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
}
