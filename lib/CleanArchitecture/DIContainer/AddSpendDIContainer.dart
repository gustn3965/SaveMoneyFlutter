import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/ViewModel/AddSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/Widget/AddSpendWidget.dart';
import 'package:save_money_flutter/main.dart';

import '../Presenter/AddSpend/AddSpend/ViewModel/DefaultAddSpendViewModel.dart';
import '../UseCase/AddSpendUseCase.dart';
import '../UseCase/GroupCategoryFetchUseCase.dart';
import '../UseCase/SpendCategoryFetchUseCase.dart';
import 'AppDIContainer.dart';

class AddSpendDIContainer {
  AppStatus appStatus;

  AddSpendDIContainer(this.appStatus);

  AddSpendViewModel makeAddSpendViewModel(
      DateTime date, AddSpendActions action) {
    AddSpendViewModel viewModel = DefaultAddSpendViewModel(
        action,
        date,
        RepoSpendCategoryFetchUseCase(appDIContainer.repository),
        RepoGroupCategoryFetchUseCase(appDIContainer.repository),
        MockAddSpendUseCase());
    return viewModel;
  }

  AddSpendWidget makeAddSpendWidget(AddSpendViewModel viewModel) {
    return AddSpendWidget(viewModel);
  }
}
