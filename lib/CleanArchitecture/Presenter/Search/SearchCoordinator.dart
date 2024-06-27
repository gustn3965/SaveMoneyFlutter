import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/ViewModel/SearchSpendViewModel.dart';
import 'package:save_money_flutter/main.dart';

import '../EditSpend/EditSpendCoordinator.dart';
import 'SearchWidget.dart';

class SearchCoordinator extends Coordinator {
  SearchSpendViewModel? searchSpendViewModel;

  SearchCoordinator(Coordinator superCoordinator)
      : super(superCoordinator, null) {
    Widget searchSpendWidget = makeSearchSpendWidget();
    // Widget emptyBottomWidget = const SizedBox(height: 100);
    routeName = "searchTab";

    currentWidget = SearchWidget(widgets: [
      searchSpendWidget,
      // emptyBottomWidget,
    ]);
  }

  @override
  void updateCurrentWidget() {
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
