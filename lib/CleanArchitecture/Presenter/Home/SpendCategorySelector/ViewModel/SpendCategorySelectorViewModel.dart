class SpendCategorySelectorItemModel {
  String categoryName;
  String categoryId;
  int count;
  SpendCategorySelectorItemModel({
    required this.categoryName,
    required this.categoryId,
    required this.count,
  });
}

class SpendCategorySelectorActions {
  final void Function(List<String>) clickSelectedSpendCategory;

  SpendCategorySelectorActions(this.clickSelectedSpendCategory);
}

abstract class SpendCategorySelectorViewModel {
  late SpendCategorySelectorActions actions;

  late List<SpendCategorySelectorItemModel> items;
  late List<SpendCategorySelectorItemModel> selectedItems;

  Future<void> fetchGroupMonthsIds(List<String> groupMonthIds);
  void didSelectSpendItem(SpendCategorySelectorItemModel item);
  void reloadFetch();

  // Observing
  Stream<SpendCategorySelectorViewModel> get dataStream;
  void dispose();
}
