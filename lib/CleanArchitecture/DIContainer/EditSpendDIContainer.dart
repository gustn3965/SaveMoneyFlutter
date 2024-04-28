import 'package:save_money_flutter/CleanArchitecture/UseCase/DaySpendListUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/EditSpendUseCase.dart';

import '../Presenter/EditSpend/ViewModel/DefaultEditSpendViewModel.dart';
import '../Presenter/EditSpend/ViewModel/EditSpendViewModel.dart';
import '../Presenter/EditSpend/Widget/EditSpendWidget.dart';
import '../UseCase/GroupCategoryFetchUseCase.dart';
import '../UseCase/SpendCategoryFetchUseCase.dart';
import 'AppDIContainer.dart';

class EditSpendDIContainer {
  AppStatus appStatus;

  EditSpendDIContainer(this.appStatus);

  EditSpendViewModel makeEditSpendViewModel(
      int spendId, EditSpendActions action) {
    EditSpendViewModel viewModel = DefaultEditSpendViewModel(
        MockSpendCategoryFetchUseCase(),
        MockGroupCategoryFetchUseCase(),
        MockDaySpendListUseCase(),
        MockEditSpendUseCase(),
        action,
        spendId);

    return viewModel;
  }

  EditSpendWidget makeEditSpendWidget(EditSpendViewModel viewModel) {
    return EditSpendWidget(viewModel);
  }
}
