import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendListUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/EditSpendUseCase.dart';

import '../../main.dart';
import '../Presenter/EditSpend/ViewModel/DefaultEditSpendViewModel.dart';
import '../Presenter/EditSpend/ViewModel/EditSpendViewModel.dart';
import '../Presenter/EditSpend/Widget/EditSpendWidget.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import '../UseCase/SpendCategoryFetchUseCase.dart';
import 'AppDIContainer.dart';

class EditSpendDIContainer {
  AppStatus appStatus;

  EditSpendDIContainer(this.appStatus);

  EditSpendViewModel makeEditSpendViewModel(
      String spendId, EditSpendActions action) {
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    SpendListUseCase spendListUseCase;
    EditSpendUseCase editSpendUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        spendCategoryFetchUseCase =
            RepoSpendCategoryFetchUseCase(appDIContainer.repository);
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        spendListUseCase = RepoSpendListUseCase(appDIContainer.repository);
        editSpendUseCase = RepoEditSpendUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendCategoryFetchUseCase = MockSpendCategoryFetchUseCase();
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        spendListUseCase = MockSpendListUseCase();
        editSpendUseCase = MockEditSpendUseCase();
        break;
    }

    EditSpendViewModel viewModel = DefaultEditSpendViewModel(
        spendCategoryFetchUseCase,
        groupMonthFetchUseCase,
        spendListUseCase,
        editSpendUseCase,
        action,
        spendId);

    return viewModel;
  }

  EditSpendWidget makeEditSpendWidget(EditSpendViewModel viewModel) {
    return EditSpendWidget(viewModel);
  }
}
