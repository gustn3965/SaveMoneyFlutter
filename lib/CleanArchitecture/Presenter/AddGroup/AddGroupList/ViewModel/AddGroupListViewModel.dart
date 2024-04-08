class AddGroupListViewModelListItem {
  late String groupName;
  late String addThisGroupName;
  AddGroupListViewModelListItem(this.groupName) {
    addThisGroupName = ' 추가하기 ';
  }
}

class AddGroupListActions {
  void Function(DateTime date) addNewGroup;
  void Function(DateTime date, String groupName) addCurrentGroup;

  AddGroupListActions(this.addNewGroup, this.addCurrentGroup);
}

abstract class AddGroupListViewModel {
  late AddGroupListActions actions;
  late List<AddGroupListViewModelListItem> groupCategoryItems;
  late String addGroupCategoryButtonName;

  AddGroupListViewModel(DateTime);

  void didClickAddNewGroupCategoryButton();
  void didClickAddCurrentItem(int index);

  Future<void> fetchGroupCategoryList();

  // Observing
  Stream<AddGroupListViewModel> get dataStream;
  void dispose();
}
