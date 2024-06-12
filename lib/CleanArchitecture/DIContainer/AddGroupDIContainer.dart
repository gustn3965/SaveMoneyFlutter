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
    AddGroupListViewModel viewModel = DefaultAddGroupListViewModel(
        date,
        RepoGroupCategoryFetchUseCase(appDIContainer.repository),
        RepoGroupMonthFetchUseCase(appDIContainer.repository),
        action);
    return viewModel;
  }

  AddGroupListWidget makeAddGroupListWidget(AddGroupListViewModel viewModel) {
    return AddGroupListWidget(viewModel);
  }

// Name
  AddGroupNameViewModel makeAddGroupNameViewModel(
      DateTime date, AddGroupNameActions action) {
    AddGroupNameViewModel viewModel = DefaultAddGroupNameViewModel(
        date, RepoGroupCategoryFetchUseCase(appDIContainer.repository), action);
    return viewModel;
  }

  AddGroupNameWidget makeAddGroupNameWidget(AddGroupNameViewModel viewModel) {
    return AddGroupNameWidget(viewModel);
  }

// Money
  AddGroupMoneyViewModel makeAddGroupMoneyViewModel(
      DateTime date, String groupName, AddGroupMoneyAction action) {
    AddGroupMoneyViewModel viewModel = DefaultAddGroupMoneyViewModel(
        date,
        groupName,
        action,
        RepoAddGroupMonthUseCase(appDIContainer.repository),
        RepoAddGroupCategoryUseCase(appDIContainer.repository));
    return viewModel;
  }

  AddGroupMoneyWidget makeAddGroupMoneyWidget(
      AddGroupMoneyViewModel viewModel) {
    return AddGroupMoneyWidget(viewModel);
  }
}
