import 'dart:async';
import 'package:intl/intl.dart';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/SpendCategoryChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';

import '../../../../../Extension/DateTime+Extension.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../Domain/Entity/SpendCategory.dart';
import '../../../../UseCase/SpendListUseCase.dart';

class DefaultSpendCategoryChartViewModel extends SpendCategoryChartViewModel {
  List<String> groupCategoryIds = [];

  SpendCategoryFetchUseCase spendCategoryFetchUseCase;
  SpendListUseCase spendListUseCase;

  DefaultSpendCategoryChartViewModel(super.action,
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
        .fetchSpendCategoryListWithGroupCategoryIds(
            groupCategoryIds: groupCategoryIds, exceptNoSpend: true);

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
    print("SpendCategoryChart reloadFetch");
    fetchSpendCategoryList(groupCategoryIds);
  }

  @override
  void clickChart({required int xIndex, required int yIndex}) {
    SpendChartXModel xModel = chartModel!.xModels[xIndex];
    SpendChartYModel yModel = xModel.yModels[yIndex];
    int totalMoney = xModel.yModels.fold(0, (sum, yModel) => sum + yModel.yIndex);
    String dateString = DateFormat('yyyy-MM').format(dateTimeFromSince1970(xModel.xIndex));
    SpendChartToastModel toastModel = SpendChartToastModel(categoryMoney: yModel.yIndex, categoryName: yModel.name, totalMoney: totalMoney, dateString: dateString);
    action.showToastYChart(toastModel);
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
          spendCategoryIds: [item.categoryIdentity],
          groupCategoryIds: groupCategoryIds,
          descending: true);

      // 년월 key로 SpendList만들어둠.
      Map<int, List<Spend>> groupedByYearMonth = makeDefaultGroupedByYearMonth(spendList);

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
        String groupCategoryName = spendList.firstOrNull?.spendCategory?.name ?? "";
        String spendCategoryId = spendList.firstOrNull?.spendCategory?.identity ?? "";

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
    }).toList()..sort((a, b) => b.xIndex.compareTo(a.xIndex));

    SpendChartModel chartModel = SpendChartModel(xModels);
    this.chartModel = chartModel;
  }

  Map<int, List<Spend>> makeDefaultGroupedByYearMonth(List<Spend> spendList) {
    Map<int, List<Spend>> groupedByYearMonth = {};
    // 첫월 ~ 마지막월 key를 먼저만들어둠.
    DateTime? firstDate;
    DateTime lastDate;
    if (spendList.lastOrNull != null) {
      Spend spendFirst = spendList.last;
      DateTime date = spendFirst.date;
      firstDate = DateTime(date.year, date.month);
    }
      DateTime date = DateTime.now();
      lastDate = DateTime(date.year, date.month);

    if (firstDate != null) {
      List<DateTime> monthList = [];
      DateTime currentMonth = firstDate;
      if (lastDate.isBefore(firstDate)) {
        currentMonth = lastDate;
        lastDate = firstDate;
      }

      while (currentMonth.isBefore(lastDate) || currentMonth.isAtSameMomentAs(lastDate)) {
        monthList.add(currentMonth);
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      }

      monthList.forEach((date) {
        int monthYearKey = date.millisecondsSinceEpoch;
        groupedByYearMonth[monthYearKey] = [];
      });
    }

    return groupedByYearMonth;
  }

  List<SpendCategoryChartSelectorItem> convertToItems(
      List<SpendCategory> spendCategorys) {
    return spendCategorys.map((category) {
      return SpendCategoryChartSelectorItem(
          category.identity, category.name, category.totalSpendindCount);
    }).toList();
  }
}
