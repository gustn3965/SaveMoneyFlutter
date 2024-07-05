import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/ViewModel/SearchSpendViewModel.dart';
import 'package:save_money_flutter/main.dart';

import '../EditSpend/EditSpendCoordinator.dart';
import 'SearchViewModel.dart';
import 'SearchWidget.dart';

class SearchCoordinator extends Coordinator {
  SearchSpendViewModel? searchSpendViewModel;

  SearchViewModel searchViewModel = SearchViewModel();

  SearchCoordinator(Coordinator superCoordinator)
      : super(superCoordinator, null) {
    Widget searchSpendWidget = makeSearchSpendWidget();
    // Widget emptyBottomWidget = const SizedBox(height: 100);
    routeName = "searchTab";

    currentWidget = SearchWidget(viewModel: searchViewModel, widgets: [
      searchSpendWidget,
      // emptyBottomWidget,
    ]);
  }

  @override
  void updateCurrentWidget() {
    searchViewModel.reloadData();

    searchSpendViewModel?.reloadData();
  }

  Widget makeSearchSpendWidget() {
    void showEditSpend(String spendId) {
      EditSpendCoordinator editSpendCoordinator =
      EditSpendCoordinator(this, spendId);
      editSpendCoordinator.startFromModalBottomSheet();
    }
    SearchSpendAction action =
        SearchSpendAction(didClickEditSpend: showEditSpend);

    searchSpendViewModel = appDIContainer.search.makeSearchSpendViewModel(action);

    return appDIContainer.search.makeSearchSpendWidget(searchSpendViewModel!);
  }
}
