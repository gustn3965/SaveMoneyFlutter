import 'package:save_money_flutter/CleanArchitecture/UseCase/AddSpendCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';
import 'package:save_money_flutter/main.dart';

import '../Presenter/AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';
import '../Presenter/AddSpendCategory/AddSpendCategory/ViewModel/DefaultAddSpendCategoryViewModel.dart';
import '../Presenter/AddSpendCategory/AddSpendCategory/Widget/AddSpendCategoryWidget.dart';
import 'AppDIContainer.dart';

class AddSpendCategoryDIContainer {
  AppStatus appStatus;

  AddSpendCategoryDIContainer(this.appStatus);

  AddSpendCategoryViewModel makeAddSpendCategoryViewModel(
      AddSpendCategoryActions action) {
    AddSpendCategoryUseCase addSpendCategoryUseCase;
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        addSpendCategoryUseCase =
            RepoAddSpendCategoryUseCase(appDIContainer.repository);
        spendCategoryFetchUseCase = RepoSpendCategoryFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        addSpendCategoryUseCase = MockAddSpendCategoryUseCase();
        spendCategoryFetchUseCase = MockSpendCategoryFetchUseCase();
        break;
    }

    AddSpendCategoryViewModel viewModel =
        DefaultAddSpendCategoryViewModel(action, addSpendCategoryUseCase, spendCategoryFetchUseCase);
    return viewModel;
  }

  AddSpendCategoryWidget makeAddSpendCategoryWidget(
      AddSpendCategoryViewModel viewModel) {
    return AddSpendCategoryWidget(viewModel);
  }
}
