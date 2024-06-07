class SpendCategorySelectorItemModel {
  String categoryName;
  String categoryId;
  SpendCategorySelectorItemModel({
    required this.categoryName,
    required this.categoryId,
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

  Future<void> fetchGroupMonth(String? identity);
  void didSelectSpendItem(SpendCategorySelectorItemModel item);
  void reloadFetch();

  // Observing
  Stream<SpendCategorySelectorViewModel> get dataStream;
  void dispose();
}
