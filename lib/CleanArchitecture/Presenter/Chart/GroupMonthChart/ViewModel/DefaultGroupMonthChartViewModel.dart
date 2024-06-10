import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../../../Domain/Entity/GroupCategory.dart';
import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../UseCase/GroupCategoryFetchUseCase.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';

class DefaultGroupMonthChartViewModel extends GroupMonthChartViewModel {
  @override
  late GroupMonthChartActions action;

  GroupCategoryFetchUseCase groupCategoryFetchUseCase;
  GroupMonthFetchUseCase groupMonthFetchUseCase;

  DefaultGroupMonthChartViewModel(this.action, this.groupCategoryFetchUseCase,
      this.groupMonthFetchUseCase) {
    fetchAllGroupCategory();
  }

  final _dataController =
      StreamController<GroupMonthChartViewModel>.broadcast();
  @override
  Stream<GroupMonthChartViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  @override
  void reloadFetch() async {
    fetchAllGroupCategory();
  }

  void fetchAllGroupCategory() async {
    List<GroupCategory> groupCategories =
        await groupCategoryFetchUseCase.fetchAllGroupCategoryList();

    groupCategorySelectorItems = convertToCategorySelectorItem(groupCategories);

    _dataController.add(this);
  }

  void didSelectGroupCategory(GroupCategoryChartSelectorItem item) {
    if (selectedGroupCategorySelectorItems.contains(item)) {
      selectedGroupCategorySelectorItems.remove(item);
    } else {
      selectedGroupCategorySelectorItems.add(item);
    }

    makeChartModel();

    List<String> groupCategoryIds =
        selectedGroupCategorySelectorItems.map((item) {
      return item.categoryIdentity;
    }).toList();
    action.updateSelectedGroupCategoryIds(groupCategoryIds);

    _dataController.add(this);
  }

  void makeChartModel() async {
    Map<int, List<GroupChartYModel>> map = {};

    for (GroupCategoryChartSelectorItem item
        in selectedGroupCategorySelectorItems) {
      List<GroupMonth> groupMonths = await groupMonthFetchUseCase
          .fetchGroupMonthByCategoryId(item.categoryIdentity);

      for (GroupMonth groupMonth in groupMonths) {
        int spendMoney = groupMonth.totalSpendMoney();
        int xDate = indexMonthDateIdFromDateTime(groupMonth.date);

        String groupCategoryName = groupMonth.groupCategory.name;
        String groupCategoryId = groupMonth.groupCategory.identity;
        if (map[xDate] != null) {
          map[xDate]!.add(
              GroupChartYModel(spendMoney, groupCategoryName, groupCategoryId));
        } else {
          map[xDate] = [
            GroupChartYModel(spendMoney, groupCategoryName, groupCategoryId)
          ];
        }
      }
    }

    List<GroupChartXModel> xModels = map.entries.map((entry) {
      int xIndex = entry.key;
      List<GroupChartYModel> yModels = entry.value;
      return GroupChartXModel(xIndex, yModels);
    }).toList();

    GroupChartModel chartModel = GroupChartModel(xModels);
    this.chartModel = chartModel;

    _dataController.add(this);
  }

  List<GroupCategoryChartSelectorItem> convertToCategorySelectorItem(
      List<GroupCategory> groupCategories) {
    return groupCategories.map((groupCategory) {
      return GroupCategoryChartSelectorItem(
          groupCategory.identity, groupCategory.name);
    }).toList();
  }
}
