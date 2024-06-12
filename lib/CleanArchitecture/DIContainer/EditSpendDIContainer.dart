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
    EditSpendViewModel viewModel = DefaultEditSpendViewModel(
        RepoSpendCategoryFetchUseCase(appDIContainer.repository),
        RepoGroupMonthFetchUseCase(appDIContainer.repository),
        RepoSpendListUseCase(appDIContainer.repository),
        RepoEditSpendUseCase(appDIContainer.repository),
        action,
        spendId);

    return viewModel;
  }

  EditSpendWidget makeEditSpendWidget(EditSpendViewModel viewModel) {
    return EditSpendWidget(viewModel);
  }
}
