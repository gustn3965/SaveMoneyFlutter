import 'dart:async';

class MainTabViewModelAction {
  void Function() didClickHomeBottomTabButton;
  void Function() didClickSettingBottomTabButton;
  MainTabViewModelAction(
      this.didClickHomeBottomTabButton, this.didClickSettingBottomTabButton);
}

abstract class MainTabViewModel {
  late MainTabViewModelAction action;

  MainTabViewModel(this.action);

  void didClickHomeBottomTabButton();
  void didClickSettingBottomTabButton();

  // Observing
  Stream<MainTabViewModel> get dataStream;
  void dispose();
}

class DefaultMainTabViewModel extends MainTabViewModel {
  DefaultMainTabViewModel(super.action);

  final _dataController = StreamController<MainTabViewModel>.broadcast();
  @override
  Stream<MainTabViewModel> get dataStream => _dataController.stream;

  @override
  void didClickHomeBottomTabButton() {
    action.didClickHomeBottomTabButton();
    _dataController.add(this);
  }

  @override
  void didClickSettingBottomTabButton() {
    action.didClickSettingBottomTabButton();
    _dataController.add(this);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
