import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/ViewModel/AddSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/Widget/AddSpendWidget.dart';
import 'package:save_money_flutter/main.dart';

import '../Domain/Entity/GroupMonth.dart';
import '../Presenter/AddSpend/AddSpend/ViewModel/DefaultAddSpendViewModel.dart';
import '../UseCase/AddSpendUseCase.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import '../UseCase/SpendCategoryFetchUseCase.dart';
import 'AppDIContainer.dart';

class AddSpendDIContainer {
  AppStatus appStatus;

  AddSpendDIContainer(this.appStatus);

  AddSpendViewModel makeAddSpendViewModel(
      DateTime date, GroupMonth? selectedGroupMonth, AddSpendActions action) {
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    AddSpendUseCase addSpendUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        spendCategoryFetchUseCase =
            RepoSpendCategoryFetchUseCase(appDIContainer.repository);
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        addSpendUseCase = RepoAddSpendUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendCategoryFetchUseCase = MockSpendCategoryFetchUseCase();
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        addSpendUseCase = MockAddSpendUseCase();
        break;
    }

    AddSpendViewModel viewModel = DefaultAddSpendViewModel(
        action,
        date,
        selectedGroupMonth,
        spendCategoryFetchUseCase,
        groupMonthFetchUseCase,
        addSpendUseCase);
    return viewModel;
  }

  AddSpendWidget makeAddSpendWidget(AddSpendViewModel viewModel) {
    return AddSpendWidget(viewModel);
  }
}
