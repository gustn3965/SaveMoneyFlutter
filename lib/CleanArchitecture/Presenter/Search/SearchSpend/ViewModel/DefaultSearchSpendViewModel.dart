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
  void didClickEditSpendItem(SearchSpendItemSpend item) {
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

    List<SearchSpendItem> items = [];

    Set<DateTime> dateSet = {};

    DateFormat dateFormat = DateFormat('yyyy-MM');
    for (Spend spend in spendList) {
      DateTime date =
      DateTime(spend.date.year, spend.date.month, spend.date.day);

      SearchSpendItemSpend spendItem = SearchSpendItemSpend(
          spendIdentity: spend.identity,
          groupCategoryName: spend.groupMonthId,
          spendCategoryName: spend.spendCategory?.name ?? "",
          description: spend.description,
          spendMoneyString: '${NumberFormat("#,###").format(spend.spendMoney)}원',
          dateString: DateFormat('yyyy-MM-dd').format(spend.date));

      if (dateSet.contains(date)) {
        items.add(spendItem);
      } else {
        dateSet.add(date);
        items.add(SearchSpendItemDate(dateString: dateFormat.format(date), date: date));
        items.add(spendItem);
      }
    }

    return items;
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
