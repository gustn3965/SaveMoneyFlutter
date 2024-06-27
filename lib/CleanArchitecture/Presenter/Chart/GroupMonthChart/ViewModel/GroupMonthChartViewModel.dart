class GroupCategoryChartSelectorItem {
  String categoryIdentity;
  String categoryName;
  GroupCategoryChartSelectorItem(this.categoryIdentity, this.categoryName);
}

class GroupMonthChartActions {
  final void Function(List<String>) updateSelectedGroupCategoryIds;
  final void Function(GroupChartToastModel toastModel) showToastYChart;

  GroupMonthChartActions(this.updateSelectedGroupCategoryIds, this.showToastYChart);
}

class GroupChartToastModel {
  int categoryMoney;
  String categoryName;
  int totalMoney;
  String dateString;
  GroupChartToastModel({required this.categoryMoney, required this.categoryName, required this.totalMoney, required this.dateString});
}

class GroupChartModel {
  List<GroupChartXModel> xModels;

  GroupChartModel(this.xModels);
}

class GroupChartXModel {
  int xIndex; // int를 날짜포멧으로 변환.

  List<GroupChartYModel> yModels;
  GroupChartXModel(this.xIndex, this.yModels);
}

class GroupChartYModel {
  int yIndex; // spendMonedy
  String name; // GroupCategoryName
  String groupCategoryId;

  GroupChartYModel(this.yIndex, this.name, this.groupCategoryId);
}

abstract class GroupMonthChartViewModel {
  late GroupMonthChartActions action;

  List<GroupCategoryChartSelectorItem> groupCategorySelectorItems = [];
  List<GroupCategoryChartSelectorItem> selectedGroupCategorySelectorItems = [];

  GroupChartModel? chartModel;

  void didSelectGroupCategory(GroupCategoryChartSelectorItem item);
  void clickChart({required int xIndex, required int yIndex});
  void reloadFetch();

  // Observing
  Stream<GroupMonthChartViewModel> get dataStream;
  void dispose();
}
