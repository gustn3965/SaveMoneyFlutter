import 'dart:async';
import 'package:intl/intl.dart';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/ViewModel/SearchSpendViewModel.dart';

import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/SearchSpendUseCase.dart';

class DefaultSearchSpendViewModel extends SearchSpendViewModel {
  SearchSpendUseCase searchSpendUseCase;

  DefaultSearchSpendViewModel(
      {required super.action, required this.searchSpendUseCase}) {}

  @override
  void didChangeSearchName(String searchName) {
    this.searchName = searchName;
  }

  @override
  void didClickEditSpendItem(SearchSpendItem item) {
    action.didClickEditSpend(item.spendIdentity);
  }

  @override
  void didClickSearchButton() async {
    if (searchName.trim().isEmpty) {
      return;
    }
    List<Spend> spendList =
        await searchSpendList();
    print(spendList.length);

    items = convertToItem(spendList);
    _dataController.add(this);
  }

  Future<List<Spend>> searchSpendList() async {
    return
        await searchSpendUseCase.searchSpendByCategoryNameAndDescription(
        search: searchName, descDate: true);
  }

  List<SearchSpendItem> convertToItem(List<Spend> spendList) {
    return spendList.map((e) {
      return SearchSpendItem(
          spendIdentity: e.identity,
          groupCategoryName: e.groupMonthId,
          spendCategoryName: e.spendCategory?.name ?? "",
          description: e.description,
          spendMoneyString: '${NumberFormat("#,###").format(e.spendMoney)}원',
          dateString: DateFormat('yyyy-MM-dd').format(e.date));
    }).toList();
  }

  // observing
  final _dataController = StreamController<SearchSpendViewModel>.broadcast();

  @override
  Stream<SearchSpendViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
