class LoginAddGroupNameActions {
  void Function(DateTime date, String groupName) addGroupName;

  LoginAddGroupNameActions(this.addGroupName);
}

abstract class LoginAddGroupNameViewModel {
  late LoginAddGroupNameActions addGroupNameActions;
  late String groupName;
  late bool availableConfirmButton;
late int maxNameLength;
  LoginAddGroupNameViewModel(DateTime date);

  void didChangeGroupName(String groupName);
  void didClickConfirmButton();

  // Observing
  Stream<LoginAddGroupNameViewModel> get dataStream;
  void dispose();
}
