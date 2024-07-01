
import 'dart:async';

class UserFeedbackWebViewAction {
  void Function() navigationPop;

  UserFeedbackWebViewAction(
      {required this.navigationPop});
}

class UserFeedbackWebViewModel {

  UserFeedbackWebViewAction action;

  UserFeedbackWebViewModel(this.action);

  // Observing
  final _dataController = StreamController<UserFeedbackWebViewModel>.broadcast();

  @override
  Stream<UserFeedbackWebViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  void reloadData() {
    _dataController.add(this);
  }


  void didClickNavigationPopButton() {
    action.navigationPop();
  }
}