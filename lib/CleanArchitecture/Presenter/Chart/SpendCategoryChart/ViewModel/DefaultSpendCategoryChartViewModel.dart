import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/SpendCategoryChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../Domain/Entity/SpendCategory.dart';
import '../../../../UseCase/SpendListUseCase.dart';

class DefaultSpendCategoryChartViewModel extends SpendCategoryChartViewModel {
  List<String> groupCategoryIds = [];

  SpendCategoryFetchUseCase spendCategoryFetchUseCase;
  SpendListUseCase spendListUseCase;

  DefaultSpendCategoryChartViewModel(
      this.spendCategoryFetchUseCase, this.spendListUseCase) {}

  final _dataController =
      StreamController<SpendCategoryChartViewModel>.broadcast();
  @override
  Stream<SpendCategoryChartViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  @override
  void fetchSpendCategoryList(List<String> groupCategoryIds) async {
    this.groupCategoryIds = groupCategoryIds;

    List<SpendCategory> spendCategorys = await spendCategoryFetchUseCase
        .fetchSpendCategoryListWithGroupCategoryIds(groupCategoryIds);

    spendCategorySelectorItems = convertToItems(spendCategorys);

    updateSelectedItems();

    await makeChartModel();

    _dataController.add(this);
  }

  @override
  void didSelectSpendCategory(SpendCategoryChartSelectorItem item) async {
    if (selectedSpendCategorySelectorItems.contains(item)) {
      selectedSpendCategorySelectorItems.remove(item);
    } else {
      selectedSpendCategorySelectorItems.add(item);
    }

    await makeChartModel();

    _dataController.add(this);
  }

  @override
  void reloadFetch() async {
    fetchSpendCategoryList(groupCategoryIds);
  }

  void updateSelectedItems() {
    // 새로가져온 소비카테고리기반으로 selected카테고리 업데이트
    List<SpendCategoryChartSelectorItem> shouldDeleteItems = [];
    for (SpendCategoryChartSelectorItem item
        in selectedSpendCategorySelectorItems) {
      if (spendCategorySelectorItems.contains(item) == false) {
        shouldDeleteItems.add(item);
      }
    }

    for (SpendCategoryChartSelectorItem item in shouldDeleteItems) {
      selectedSpendCategorySelectorItems.remove(item);
    }
  }

  Future<void> makeChartModel() async {
    Map<int, List<SpendChartYModel>> map = {};

    for (SpendCategoryChartSelectorItem item
        in selectedSpendCategorySelectorItems) {
      List<Spend> spendList = await spendListUseCase.fetchSpendList(
          spendCategoryId: item.categoryIdentity,
          groupCategoryIds: groupCategoryIds,
          descending: false);

      // 년월 key로 SpendList만들어둠.
      Map<int, List<Spend>> groupedByYearMonth = {};
      for (var spend in spendList) {
        DateTime date = spend.date;
        DateTime monthYearDate = DateTime(date.year, date.month);
        int monthYearKey = monthYearDate.millisecondsSinceEpoch;

        // Add to the grouped map
        if (!groupedByYearMonth.containsKey(monthYearKey)) {
          groupedByYearMonth[monthYearKey] = [];
        }
        groupedByYearMonth[monthYearKey]!.add(spend);
      }

      // 년월 key로 SpendChartYModel로 만들어둠.
      groupedByYearMonth.forEach((key, spendList) {
        int totalSpendMoney =
            spendList.fold(0, (sum, item) => sum + item.spendMoney);
        String groupCategoryName = spendList.first.spendCategory?.name ?? "";
        String spendCategoryId = spendList.first.spendCategory?.identity ?? "";

        if (!map.containsKey(key)) {
          map[key] = [];
        }
        map[key]!.add(SpendChartYModel(
            yIndex: totalSpendMoney,
            name: groupCategoryName,
            spendCategoryId: spendCategoryId));
      });
    }

    List<SpendChartXModel> xModels = map.entries.map((entry) {
      int xIndex = entry.key;
      List<SpendChartYModel> yModels = entry.value;
      return SpendChartXModel(xIndex, yModels);
    }).toList();

    SpendChartModel chartModel = SpendChartModel(xModels);
    this.chartModel = chartModel;
  }

  List<SpendCategoryChartSelectorItem> convertToItems(
      List<SpendCategory> spendCategorys) {
    return spendCategorys.map((category) {
      return SpendCategoryChartSelectorItem(category.identity, category.name);
    }).toList();
  }
}
