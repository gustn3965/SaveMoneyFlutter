import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/AppNotice/ViewModel/AppNoticeViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/AppNotice/Widget/AppNoticeWebView.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupCategory/ViewModel/DefaultEditGroupCategoryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupCategory/ViewModel/EditGroupCategoryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupCategory/Widget/EditGroupCategoryWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupMonthMoney/ViewModel/DefaultEditGroupMonthMoneyViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupMonthMoney/ViewModel/EditGroupMonthMoneyViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupMonthMoney/Widget/EditGroupMonthMoneyWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/GroupCategoryList/ViewModel/DefaultGroupCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/GroupCategoryList/ViewModel/GroupCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/GroupCategoryList/Widget/GroupCategoryListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/DefaultSpendCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/Widget/SpendCategoryListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/UserFeedback/ViewModel/UserFeedbackWebViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/UserFeedback/Widget/UserFeedbackWebView.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/EditGroupCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';
import 'package:save_money_flutter/main.dart';

import '../Presenter/Settings/EditSpendCategory/ViewModel/DefaultEditSpendCategoryViewModel.dart';
import '../Presenter/Settings/EditSpendCategory/ViewModel/EditSpendCategoryViewModel.dart';
import '../Presenter/Settings/EditSpendCategory/Widget/EditSpendCategoryWidget.dart';
import '../Presenter/Settings/Setting/ViewModel/DefaultSettingsViewModel.dart';
import '../Presenter/Settings/Setting/ViewModel/SettingsViewModel.dart';
import '../Presenter/Settings/Setting/Widget/SettingsWidget.dart';
import '../UseCase/EditGroupMonthUseCase.dart';
import '../UseCase/EditSpendCategoryUseCase.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import '../UseCase/SpendListUseCase.dart';

class SettingsDIContainer {
  AppStatus appStatus;

  SettingsDIContainer(this.appStatus);

  SettingsViewModel makeSettingsViewModel(SettingsAction action) {
    return DefaultSettingsViewModel(action);
  }

  Widget makeSettingsWidget(SettingsViewModel viewModel) {
    return SettingsWidget(viewModel);
  }

  SpendCategoryListViewModel makeSpendCategoryListViewModel(
      SpendCategoryListAction action) {
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;

    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        spendCategoryFetchUseCase =
            RepoSpendCategoryFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendCategoryFetchUseCase = MockSpendCategoryFetchUseCase();
        break;
    }

    return DefaultSpendCategoryListViewModel(
        action: action, spendCategoryFetchUseCase: spendCategoryFetchUseCase);
  }

  Widget makeSpendCategoryListWidget(SpendCategoryListViewModel viewModel) {
    return SpendCategoryListWidget(viewModel);
  }

  GroupCategoryListViewModel makeGroupCategoryListViewModel(
      GroupCategoryListAction action) {
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

    return DefaultGroupCategoryListViewModel(
        action: action, groupCategoryFetchUseCase: groupCategoryFetchUseCase);
  }

  Widget makeGroupCategoryListWidget(GroupCategoryListViewModel viewModel) {
    return GroupCategoryListWidget(viewModel);
  }

  // EditSpendCategory
  EditSpendCategoryViewModel makeEditSpendCategoryViewModel(
      {required EditSpendCategoryActions action,
      required String spendCategoryId}) {
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;
    EditSpendCategoryUseCase editSpendCategoryUseCase;
    SpendListUseCase spendListUseCase;
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        spendCategoryFetchUseCase =
            RepoSpendCategoryFetchUseCase(appDIContainer.repository);
        editSpendCategoryUseCase =
            RepoEditSpendCategoryUseCase(appDIContainer.repository);
        spendListUseCase = RepoSpendListUseCase(appDIContainer.repository);
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendCategoryFetchUseCase = MockSpendCategoryFetchUseCase();
        editSpendCategoryUseCase = MockEditSpendCategoryUseCase();
        spendListUseCase = MockSpendListUseCase();
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }

    EditSpendCategoryViewModel viewModel = DefaultEditSpendCategoryViewModel(
        actions: action,
        spendCategoryId: spendCategoryId,
        spendCategoryFetchUseCase: spendCategoryFetchUseCase,
        editSpendCategoryUseCase: editSpendCategoryUseCase,
        spendListUseCase: spendListUseCase,
        groupMonthFetchUseCase: groupMonthFetchUseCase);
    return viewModel;
  }

  Widget makeEditSpendCategoryWidget(
      EditSpendCategoryViewModel viewModel) {
    return EditSpendCategoryWidget(viewModel);
  }

  // EditGroupCategory
  EditGroupCategoryViewModel makeEditGroupCategoryViewModel(
      EditGroupCategoryActions actions, String groupCategoryId) {
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    GroupCategoryFetchUseCase groupCategoryFetchUseCase;
    EditGroupCategoryUseCase editGroupCategoryUseCase;

    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        groupCategoryFetchUseCase =
            RepoGroupCategoryFetchUseCase(appDIContainer.repository);
        editGroupCategoryUseCase =
            RepoEditGroupCategoryUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        groupCategoryFetchUseCase = MockGroupCategoryFetchUseCase();
        editGroupCategoryUseCase = MockEditGroupCategoryUseCase();
        break;
    }

    return DefaultEditGroupCategoryViewModel(
        actions: actions,
        groupCategoryId: groupCategoryId,
        groupMonthFetchUseCase: groupMonthFetchUseCase,
        groupCategoryFetchUseCase: groupCategoryFetchUseCase,
        editGroupCategoryUseCase: editGroupCategoryUseCase);
  }

  Widget makeEditGroupCategoryWidget(
      EditGroupCategoryViewModel viewModel) {
    return EditGroupCategoryWidget(viewModel);
  }

  // EditGroupMonthMoney

  EditGroupMonthMoneyViewModel makeEditGroupMonthMoneyViewModel(
      EditGroupMonthMoneyAction actions, String groupMonthId) {
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    EditGroupMonthUseCase editGroupMonthUseCase;

    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        editGroupMonthUseCase =
            RepoEditGroupMonthUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        editGroupMonthUseCase = MockEditGroupMonthUseCase();
        break;
    }

    return DefaultEditGroupMonthMoneyViewModel(
        groupMonthId, actions, groupMonthFetchUseCase, editGroupMonthUseCase);
  }

  Widget makeEditGroupMonthMoneyWidget(
      EditGroupMonthMoneyViewModel viewModel) {
    return EditGroupMonthMoneyWidget(viewModel);
  }


  AppNoticeWebViewModel makeAppNoticeWebViewModel(AppNoticeWebViewAction action) {
    return AppNoticeWebViewModel(action);
  }

  Widget makeAppNoticeWebView(AppNoticeWebViewModel viewModel) {
    return AppNoticeWebView(viewModel);
  }

  UserFeedbackWebViewModel makeUserFeedbackWebViewModel(UserFeedbackWebViewAction action) {
    return UserFeedbackWebViewModel(action);
  }

  Widget makeUserFeedbackWebView(UserFeedbackWebViewModel viewModel) {
    return UserFeedbackWebView(viewModel);
  }
}
