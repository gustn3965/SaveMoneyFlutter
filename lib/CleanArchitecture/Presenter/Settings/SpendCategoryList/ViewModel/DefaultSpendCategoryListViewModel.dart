import 'dart:async';

import '../../../../Domain/Entity/SpendCategory.dart';
import '../../../../UseCase/SpendCategoryFetchUseCase.dart';
import 'SpendCategoryListViewModel.dart';

class DefaultSpendCategoryListViewModel extends SpendCategoryListViewModel {
  @override
  late SpendCategoryListAction action;
  @override
  late List<SpendCategoryListItem> items = [];

  late SpendCategoryFetchUseCase spendCategoryFetchUseCase;

  DefaultSpendCategoryListViewModel(
      {required this.action, required this.spendCategoryFetchUseCase}) {
    fetchSpendCategoryList();
  }
  @override
  void clickEditSpendCategoryItem(SpendCategoryListItem item) {
    action.showEditSpendCategoryWidget(item.categoryId);
  }

  @override
  void clickAddSpendCategory() {
    action.showAddSpendCategoryWidget();
  }

  @override
  void reloadData() {
    fetchSpendCategoryList();
  }

  void fetchSpendCategoryList() async {
    List<SpendCategory> spendCategoryList =
        await spendCategoryFetchUseCase.fetchSpendCategoryList();
    items = convertToItem(spendCategoryList);

    _dataController.add(this);
  }

  List<SpendCategoryListItem> convertToItem(
      List<SpendCategory> spendCategoryList) {
    return spendCategoryList
        .map((e) => SpendCategoryListItem(e.name, e.identity, "수정하기"))
        .toList();
  }

  // Observing
  final _dataController =
      StreamController<SpendCategoryListViewModel>.broadcast();
  Stream<SpendCategoryListViewModel> get dataStream => _dataController.stream;
  void dispose() {
    _dataController.close();
  }
}
