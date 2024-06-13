import 'package:save_money_flutter/CleanArchitecture/UseCase/AddSpendCategoryUseCase.dart';
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
    switch (appStatus) {
      case AppStatus.db:
        addSpendCategoryUseCase =
            RepoAddSpendCategoryUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        addSpendCategoryUseCase = MockAddSpendCategoryUseCase();
        break;
    }

    AddSpendCategoryViewModel viewModel =
        DefaultAddSpendCategoryViewModel(action, addSpendCategoryUseCase);
    return viewModel;
  }

  AddSpendCategoryWidget makeAddSpendCategoryWidget(
      AddSpendCategoryViewModel viewModel) {
    return AddSpendCategoryWidget(viewModel);
  }
}
