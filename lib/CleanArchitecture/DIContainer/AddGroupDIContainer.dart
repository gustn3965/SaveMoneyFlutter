import 'package:save_money_flutter/main.dart';

import '../Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';
import '../Presenter/AddGroup/AddGroupList/ViewModel/DefaultAddGroupListViewModel.dart';
import '../Presenter/AddGroup/AddGroupList/Widget/AddGroupListWidget.dart';
import '../Presenter/AddGroup/AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';
import '../Presenter/AddGroup/AddGroupMoney/ViewModel/DefaultAddGroupMoneyViewModel.dart';
import '../Presenter/AddGroup/AddGroupMoney/Widget/AddGroupMoneyWidget.dart';
import '../Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';
import '../Presenter/AddGroup/AddGroupName/ViewModel/DefaultAddGroupNameViewModel.dart';
import '../Presenter/AddGroup/AddGroupName/Widget/AddGroupNameWidget.dart';
import '../UseCase/AddGroupCategoryUseCase.dart';
import '../UseCase/AddGroupMonthUseCase.dart';
import '../UseCase/GroupCategoryFetchUseCase.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import 'AppDIContainer.dart';

class AddGroupDIContainer {
  AppStatus appStatus;

  AddGroupDIContainer(this.appStatus);

  // List
  AddGroupListViewModel makeAddGroupListViewModel(
      DateTime date, AddGroupListActions action) {
    GroupCategoryFetchUseCase groupCategoryFetchUseCase;
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupCategoryFetchUseCase =
            RepoGroupCategoryFetchUseCase(appDIContainer.repository);
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupCategoryFetchUseCase = MockGroupCategoryFetchUseCase();
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }

    AddGroupListViewModel viewModel = DefaultAddGroupListViewModel(
        date, groupCategoryFetchUseCase, groupMonthFetchUseCase, action);
    return viewModel;
  }

  AddGroupListWidget makeAddGroupListWidget(AddGroupListViewModel viewModel) {
    return AddGroupListWidget(viewModel);
  }

// Name
  AddGroupNameViewModel makeAddGroupNameViewModel(
      DateTime date, AddGroupNameActions action) {
    GroupCategoryFetchUseCase groupCategoryFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupCategoryFetchUseCase =
            RepoGroupCategoryFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupCategoryFetchUseCase = MockGroupCategoryFetchUseCase();
        break;
    }

    AddGroupNameViewModel viewModel =
        DefaultAddGroupNameViewModel(date, groupCategoryFetchUseCase, action);
    return viewModel;
  }

  AddGroupNameWidget makeAddGroupNameWidget(AddGroupNameViewModel viewModel) {
    return AddGroupNameWidget(viewModel);
  }

// Money
  AddGroupMoneyViewModel makeAddGroupMoneyViewModel(
      DateTime date, String groupName, AddGroupMoneyAction action) {
    AddGroupMonthUseCase addGroupMonthUseCase;
    AddGroupCategoryUseCase addGroupCategoryUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        addGroupMonthUseCase =
            RepoAddGroupMonthUseCase(appDIContainer.repository);
        addGroupCategoryUseCase =
            RepoAddGroupCategoryUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        addGroupMonthUseCase = MockAddGroupMonthUseCase();
        addGroupCategoryUseCase = MockAddGroupCategoryUseCase();
        break;
    }
    AddGroupMoneyViewModel viewModel = DefaultAddGroupMoneyViewModel(
        date, groupName, action, addGroupMonthUseCase, addGroupCategoryUseCase);
    return viewModel;
  }

  AddGroupMoneyWidget makeAddGroupMoneyWidget(
      AddGroupMoneyViewModel viewModel) {
    return AddGroupMoneyWidget(viewModel);
  }
}
