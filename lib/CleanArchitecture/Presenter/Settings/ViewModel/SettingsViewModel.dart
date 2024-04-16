import 'dart:async';

class SettingsViewModelListItem {
  String name;

  SettingsViewModelListItem(this.name);
}

class SettingsAction {
  void Function() clickToMoveLogin;
  SettingsAction(this.clickToMoveLogin);
}

abstract class SettingsViewModel {
  late List<SettingsViewModelListItem> list;

  late SettingsAction action;

  SettingsViewModel(this.action);

  // Observing
  Stream<SettingsViewModel> get dataStream;
  void dispose();

  void didClickCell(int index);
}

class DefaultSettingsViewModel extends SettingsViewModel {
  DefaultSettingsViewModel(super.action) {
    fetchList();
  }

  final _dataController = StreamController<SettingsViewModel>.broadcast();
  @override
  Stream<SettingsViewModel> get dataStream => _dataController.stream;

  void fetchList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    list = [
      SettingsViewModelListItem("로그인화면"),
      SettingsViewModelListItem("지출 항목")
    ];

    _dataController.add(this);
  }

  @override
  void didClickCell(int index) {
    if (index == 0) {
      action.clickToMoveLogin();
    } else {
      print("아직 개발안됌");
    }
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
