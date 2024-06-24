
import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/ViewModel/DefaultSearchSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/ViewModel/SearchSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/Widget/SearchSpendWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SearchSpendUseCase.dart';
import 'package:save_money_flutter/main.dart';

import 'AppDIContainer.dart';

class SearchDIContainer {
  AppStatus appStatus;

  SearchDIContainer(this.appStatus);

  SearchSpendViewModel makeSearchSpendViewModel(SearchSpendAction action) {
    SearchSpendUseCase searchSpendUseCase;
    switch (appStatus) {
      case AppStatus.cbt || AppStatus.real:
        searchSpendUseCase =
            RepoSearchSpendUseCaes(appDIContainer.repository);
        break;
      case AppStatus.mock:
        searchSpendUseCase = MockSearchSpendUseCase();
        break;
    }

    return DefaultSearchSpendViewModel(action: action, searchSpendUseCase: searchSpendUseCase);
  }

  Widget makeSearchSpendWidget(SearchSpendViewModel viewModel) {
    return SearchSpendWidget(viewModel);
  }
}