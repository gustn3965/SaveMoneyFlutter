class AddGroupNameActions {
  void Function() cancelAddGroupName;
  void Function(DateTime date, String groupName) addGroupName;
  void Function() hasAlreadyCategoryName;
  void Function() showAppGuide;

  AddGroupNameActions(
      this.cancelAddGroupName, this.addGroupName, this.hasAlreadyCategoryName, this.showAppGuide);
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
  void didClickShowAppGuideButton();

  void reloadData();
  // Observing
  Stream<AddGroupNameViewModel> get dataStream;
  void dispose();
}
