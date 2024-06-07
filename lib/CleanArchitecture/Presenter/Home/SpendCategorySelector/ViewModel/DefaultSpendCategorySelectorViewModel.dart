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
  String groupMonthIdentity = "";

  DefaultSpendCategorySelectorViewModel(
      this.groupMonthFetchUseCase, this.actions) {
    items = [];
    selectedItems = [];
  }

  @override
  Future<void> fetchGroupMonth(String? identity) async {
    selectedItems = [];
    groupMonthIdentity = identity ?? "";
    GroupMonth? groupMonth =
        await groupMonthFetchUseCase.fetchGroupMonthByGroupId(identity);

    items = convertGroupMonthToItems(groupMonth);

    _dataController.add(this);
  }

  @override
  void didSelectSpendItem(SpendCategorySelectorItemModel item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
      print("removed...");
    } else {
      selectedItems.add(item);
      print("added...");
    }
    print(selectedItems);

    actions.clickSelectedSpendCategory(selectedItems.map((item) {
      return item.categoryId;
    }).toList());

    _dataController.add(this);
  }

  @override
  void reloadFetch() {}

  List<SpendCategorySelectorItemModel> convertGroupMonthToItems(
      GroupMonth? groupMonth) {
    Map<String, SpendCategory> map = {};

    for (Spend spend in groupMonth?.spendList ?? []) {
      if (spend.spendCategory != null) {
        map[spend.spendCategory!.identity ?? ""] = spend.spendCategory!;
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
