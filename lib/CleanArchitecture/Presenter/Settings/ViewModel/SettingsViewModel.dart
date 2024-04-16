import 'dart:async';

class SettingsViewModelListItem {
  String name;

  SettingsViewModelListItem(this.name);
}

abstract class SettingsViewModel {
  late List<SettingsViewModelListItem> list;

  // Observing
  Stream<SettingsViewModel> get dataStream;
  void dispose();
}

class DefaultSettingsViewModel extends SettingsViewModel {
  DefaultSettingsViewModel() {
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
  void dispose() {
    _dataController.close();
  }
}
