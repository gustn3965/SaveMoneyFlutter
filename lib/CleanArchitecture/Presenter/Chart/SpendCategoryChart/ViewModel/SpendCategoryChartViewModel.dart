class SpendCategoryChartSelectorItem {
  String categoryIdentity;
  String categoryName;
  int totalCountOfSpendind;
  SpendCategoryChartSelectorItem(
      this.categoryIdentity, this.categoryName, this.totalCountOfSpendind);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final SpendCategoryChartSelectorItem otherItem =
        other as SpendCategoryChartSelectorItem;
    return categoryIdentity == otherItem.categoryIdentity;
  }

  @override
  int get hashCode => categoryIdentity.hashCode;
}

// class GroupMonthChartActions {
//   final void Function(List<String>) updateSelectedGroupIds;
//   final void Function() showAddGroup;
//
//   GroupMonthSelectorActions(this.updateSelectedGroupIds, this.showAddGroup);
// }

class SpendChartModel {
  List<SpendChartXModel> xModels;

  SpendChartModel(this.xModels);
}

class SpendChartXModel {
  int xIndex; // int를 날짜포멧으로 변환.

  List<SpendChartYModel> yModels;
  SpendChartXModel(this.xIndex, this.yModels);
}

class SpendChartYModel {
  int yIndex; // spendMonedy
  String name; // GroupCategoryName
  String spendCategoryId;

  SpendChartYModel(
      {required this.yIndex,
      required this.name,
      required this.spendCategoryId});
}

abstract class SpendCategoryChartViewModel {
  List<String> selectedGroupCategoryIds = [];
  List<SpendCategoryChartSelectorItem> spendCategorySelectorItems = [];
  List<SpendCategoryChartSelectorItem> selectedSpendCategorySelectorItems = [];

  SpendChartModel? chartModel;

  void fetchSpendCategoryList(List<String> groupCategoryIds);
  void didSelectSpendCategory(SpendCategoryChartSelectorItem item);
  void reloadFetch();

  // Observing
  Stream<SpendCategoryChartViewModel> get dataStream;
  void dispose();
}
