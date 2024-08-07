class AddGroupListViewModelListItem {
  late String groupName;
  late String addThisGroupName;
  late bool isAddedGroup;
  AddGroupListViewModelListItem(this.groupName, this.isAddedGroup) {
    if (isAddedGroup) {
      addThisGroupName = ' 이미 추가됨 ';
    } else {
      addThisGroupName = ' 추가하기 ';
    }
  }
}

class AddGroupListActions {
  void Function(DateTime date) addNewGroup;
  void Function(DateTime date, String groupName) addCurrentGroup;
  void Function() navigationPop;

  AddGroupListActions(
      this.addNewGroup, this.addCurrentGroup, this.navigationPop);
}

abstract class AddGroupListViewModel {
  late AddGroupListActions actions;
  late List<AddGroupListViewModelListItem> groupCategoryItems;
  late String addGroupCategoryButtonName;

  AddGroupListViewModel(DateTime);

  void didClickAddNewGroupCategoryButton();
  void didClickAddCurrentItem(int index);
  void didClickNavigationPopButton();

  Future<void> fetchGroupCategoryList();

  // Observing
  Stream<AddGroupListViewModel> get dataStream;
  void dispose();
}
