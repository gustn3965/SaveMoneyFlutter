
import 'dart:async';

class AppNoticeWebViewAction {
  void Function() navigationPop;

  AppNoticeWebViewAction(
      {required this.navigationPop});
}

class AppNoticeWebViewModel {

  AppNoticeWebViewAction action;

  AppNoticeWebViewModel(this.action);

  // Observing
  final _dataController = StreamController<AppNoticeWebViewModel>.broadcast();

  @override
  Stream<AppNoticeWebViewModel> get dataStream => _dataController.stream;

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