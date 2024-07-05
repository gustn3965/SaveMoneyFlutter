
import 'dart:async';

class AppGuideAction {
  void Function() clickStart;

  AppGuideAction({required this.clickStart});
}
class AppGuideViewModel {

  AppGuideAction action;

  AppGuideViewModel(this.action);

  // Observing
  final _dataController = StreamController<AppGuideViewModel>.broadcast();

  @override
  Stream<AppGuideViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }

  void clickStartButton() {
    action.clickStart();
  }

  void reloadData() {
    _dataController.add(this);
  }
}