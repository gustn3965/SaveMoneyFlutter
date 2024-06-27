class AddGroupNameActions {
  void Function() cancelAddGroupName;
  void Function(DateTime date, String groupName) addGroupName;
  void Function() hasAlreadyCategoryName;

  AddGroupNameActions(
      this.cancelAddGroupName, this.addGroupName, this.hasAlreadyCategoryName);
}

abstract class AddGroupNameViewModel {
  late AddGroupNameActions addGroupNameActions;
  late String groupName;
  late bool availableConfirmButton;
  late int maxNameLength;

  AddGroupNameViewModel(DateTime date);

  void didChangeGroupName(String groupName);
  void didClickConfirmButton();
  void didClickCancelButton();

  void reloadData();
  // Observing
  Stream<AddGroupNameViewModel> get dataStream;
  void dispose();
}
