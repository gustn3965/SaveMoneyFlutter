import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditSpendCategory/ViewModel/DefaultEditSpendCategoryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditSpendCategory/ViewModel/EditSpendCategoryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/EditSpendCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendListUseCase.dart';
import 'package:save_money_flutter/main.dart';

import '../Presenter/Settings/EditSpendCategory/Widget/EditSpendCategoryWidget.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import 'AppDIContainer.dart';

class EditSpendCategoryDIContainer {
  AppStatus appStatus;

  EditSpendCategoryDIContainer(this.appStatus);

  EditSpendCategoryViewModel makeEditSpendCategoryViewModel(
      {required EditSpendCategoryActions action,
      required String spendCategoryId}) {
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;
    EditSpendCategoryUseCase editSpendCategoryUseCase;
    SpendListUseCase spendListUseCase;
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.db:
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

  EditSpendCategoryWidget makeEditSpendCategoryWidget(
      EditSpendCategoryViewModel viewModel) {
    return EditSpendCategoryWidget(viewModel);
  }
}
