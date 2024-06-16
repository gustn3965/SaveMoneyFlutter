class GroupCategoryListAction {
  void Function(String groupCategoryId) showEditGroupCategoryWidget;
  GroupCategoryListAction({required this.showEditGroupCategoryWidget});
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

  void clickEditGroupCategoryItem(GroupCategoryListItem item);
  void reloadData();
  // Observing
  Stream<GroupCategoryListViewModel> get dataStream;
  void dispose();
}
