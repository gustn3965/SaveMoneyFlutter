class GroupCategoryListAction {
  void Function(String groupCategoryId) showEditGroupCategoryWidget;
  void Function() navigationPop;

  GroupCategoryListAction(
      {required this.showEditGroupCategoryWidget, required this.navigationPop});
}

class GroupCategoryListItem {
  String name;
  String categoryId;
  String editStringName;

  GroupCategoryListItem(this.name, this.categoryId, this.editStringName);
}

abstract class GroupCategoryListViewModel {
  late GroupCategoryListAction action;

  late List<GroupCategoryListItem> items;

  void didClickNavigationPopButton();

  void clickEditGroupCategoryItem(GroupCategoryListItem item);

  void reloadData();

  // Observing
  Stream<GroupCategoryListViewModel> get dataStream;

  void dispose();
}
