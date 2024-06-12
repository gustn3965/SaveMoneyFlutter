import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupMonthUseCase.dart';
import 'package:save_money_flutter/main.dart';

import '../Presenter/Login/AddGroupMoney/ViewModel/DefaultLoginAddGroupMoneyViewModel.dart';
import '../Presenter/Login/AddGroupMoney/ViewModel/LoginAddGroupMoneyViewModel.dart';
import '../Presenter/Login/AddGroupMoney/Widget/LoginAddGroupMoneyWidget.dart';
import '../Presenter/Login/AddGroupName/ViewModel/DefaultLoginAddGroupNameViewModel.dart';
import '../Presenter/Login/AddGroupName/ViewModel/LoginAddGroupNameViewModel.dart';
import '../Presenter/Login/AddGroupName/Widget/LoginAddGroupNameWidget.dart';
import '../UseCase/AddGroupCategoryUseCase.dart';
import 'AppDIContainer.dart';

class LoginDIContainer {
  AppStatus appStatus;

  LoginDIContainer(this.appStatus);

  // Login - Add Group Name
  LoginAddGroupNameViewModel makeLoginAddGroupNameViewModel(
      DateTime date, LoginAddGroupNameActions action) {
    LoginAddGroupNameViewModel viewModel =
        DefaultLoginAddGroupNameViewModel(DateTime.now(), action);
    return viewModel;
  }

  Widget makeLoginAddGroupNameWidget(LoginAddGroupNameViewModel viewModel) {
    return LoginAddGroupNameWidget(viewModel);
  }

  // Login - Add Group Name
  LoginAddGroupMoneyViewModel makeLoginAddGroupMoneyViewModel(
      DateTime date, String categoryName, LoginAddGroupMoneyAction action) {
    LoginAddGroupMoneyViewModel viewModel = DefaultLoginAddGroupMoneyViewModel(
        date,
        categoryName,
        action,
        RepoAddGroupMonthUseCase(appDIContainer.repository),
        RepoAddGroupCategoryUseCase(appDIContainer.repository));
    return viewModel;
  }

  Widget makeLoginAddGroupMoneyWidget(LoginAddGroupMoneyViewModel viewModel) {
    return LoginAddGroupMoneyWidget(viewModel);
  }
}
