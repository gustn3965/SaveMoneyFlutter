import 'dart:async';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/SpendCategorySelectorViewModel.dart';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';

class DefaultSpendCategorySelectorViewModel
    extends SpendCategorySelectorViewModel {
  @override
  late SpendCategorySelectorActions actions;
  @override
  late List<SpendCategorySelectorItemModel> items;
  @override
  late List<SpendCategorySelectorItemModel> selectedItems;

  final GroupMonthFetchUseCase groupMonthFetchUseCase;
  List<String> groupMonthIds = [];

  DefaultSpendCategorySelectorViewModel(
      this.groupMonthFetchUseCase, this.actions) {
    items = [];
    selectedItems = [];
  }

  @override
  Future<void> fetchGroupMonthsIds(List<String> groupMonthIds) async {
    selectedItems = [];
    this.groupMonthIds = groupMonthIds;
    List<GroupMonth> groupMonths =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupIds(groupMonthIds);

    items = convertGroupMonthToItems(groupMonths);

    _dataController.add(this);
  }

  @override
  void didSelectSpendItem(SpendCategorySelectorItemModel item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }

    actions.clickSelectedSpendCategory(selectedItems.map((item) {
      return item.categoryId;
    }).toList());

    _dataController.add(this);
  }

  @override
  void reloadFetch() {
    fetchGroupMonthsIds(groupMonthIds);
  }

  List<SpendCategorySelectorItemModel> convertGroupMonthToItems(
      List<GroupMonth> groupMonths) {
    Map<String, SpendCategory> map = {};

    for (GroupMonth group in groupMonths) {
      for (Spend spend in group.spendList ?? []) {
        if (spend.spendCategory != null) {
          map[spend.spendCategory!.identity ?? ""] = spend.spendCategory!;
        }
      }
    }

    return map.entries.map((entry) {
      return SpendCategorySelectorItemModel(
        categoryName: entry.value.name,
        categoryId: entry.value.identity,
      );
    }).toList();
  }

  // Observing
  final _dataController =
      StreamController<SpendCategorySelectorViewModel>.broadcast();
  @override
  Stream<SpendCategorySelectorViewModel> get dataStream =>
      _dataController.stream;
  @override
  void dispose() {
    _dataController.close();
  }
}
