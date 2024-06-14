import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/DefaultSpendCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/Widget/SpendCategoryListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';
import 'package:save_money_flutter/main.dart';

import '../Presenter/Settings/Setting/ViewModel/DefaultSettingsViewModel.dart';
import '../Presenter/Settings/Setting/ViewModel/SettingsViewModel.dart';
import '../Presenter/Settings/Setting/Widget/SettingsWidget.dart';

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
      case AppStatus.db:
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
}
