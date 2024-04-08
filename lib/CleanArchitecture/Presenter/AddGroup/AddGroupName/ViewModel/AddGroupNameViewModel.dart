class AddGroupNameActions {
  void Function() cancelAddGroupName;
  void Function(DateTime date, String groupName) addGroupName;

  AddGroupNameActions(this.cancelAddGroupName, this.addGroupName);
}

abstract class AddGroupNameViewModel {
  late AddGroupNameActions addGroupNameActions;
  late String groupName;
  late bool availableConfirmButton;

  AddGroupNameViewModel(DateTime date);

  void didChangeGroupName(String groupName);
  void didClickConfirmButton();
  void didClickCancelButton();

  // Observing
  Stream<AddGroupNameViewModel> get dataStream;
  void dispose();
}
