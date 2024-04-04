class AddGroupListViewModelListItem {
  late String groupName;
  late String addThisGroupName;
  AddGroupListViewModelListItem(this.groupName) {
    addThisGroupName = ' 추가하기 ';
  }
}

abstract class AddGroupListViewModel {
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
