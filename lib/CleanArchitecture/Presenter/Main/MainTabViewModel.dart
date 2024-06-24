import 'dart:async';

import 'package:flutter/material.dart'; // ㅠㅠ Icon때문에. ViewModel에는 Widget관련 안쓰려고했지만...

class MainTabViewModelAction {
  void Function() didClickHomeBottomTabButton;
  void Function() didClickChartBottomTabButton;
  void Function() didClickSearchBottomTabButton;
  void Function() didClickSettingBottomTabButton;
  MainTabViewModelAction({required this.didClickHomeBottomTabButton,
    required this.didClickChartBottomTabButton, required this.didClickSearchBottomTabButton, required this.didClickSettingBottomTabButton});
}

class MainTabItem {
  Icon icon;
  String name;

  void Function() clickTabAction;
  MainTabItem({required this.icon, required this.name, required this.clickTabAction});
}
abstract class MainTabViewModel {

  List<MainTabItem> tabItems = [];
  late MainTabViewModelAction action;
  int bottomNavigationIndex = 0;

  MainTabViewModel(this.action);

  void didClickTabItem(MainTabItem item);

  void didClickHomeBottomTabButton();
  void didClickChartBottomTabButton();
  void didClickSearchBottomTabButton();
  void didClickSettingBottomTabButton();


  // Observing
  Stream<MainTabViewModel> get dataStream;
  void dispose();
}

class DefaultMainTabViewModel extends MainTabViewModel {
  DefaultMainTabViewModel(super.action) {
    tabItems = [
      MainTabItem(icon: Icon(Icons.home), name: "홈", clickTabAction: didClickHomeBottomTabButton),
      MainTabItem(icon: Icon(Icons.bar_chart), name: "차트", clickTabAction: didClickChartBottomTabButton),
      MainTabItem(icon: Icon(Icons.search), name: "검색", clickTabAction: didClickSearchBottomTabButton),
      MainTabItem(icon: Icon(Icons.menu), name: "설정", clickTabAction: didClickSettingBottomTabButton),
    ];
  }

  final _dataController = StreamController<MainTabViewModel>.broadcast();
  @override
  Stream<MainTabViewModel> get dataStream => _dataController.stream;

  @override
  void didClickTabItem(MainTabItem item) {
    item.clickTabAction();
  }

  @override
  void didClickHomeBottomTabButton() {
    action.didClickHomeBottomTabButton();
    bottomNavigationIndex = 0;
    _dataController.add(this);
  }

  @override
  void didClickChartBottomTabButton() {
    action.didClickChartBottomTabButton();
    bottomNavigationIndex = 1;
    _dataController.add(this);
  }

  @override
  void didClickSearchBottomTabButton() {
    action.didClickSearchBottomTabButton();
    bottomNavigationIndex = 2;
    _dataController.add(this);
  }

  @override
  void didClickSettingBottomTabButton() {
    action.didClickSettingBottomTabButton();
    bottomNavigationIndex = 3;
    _dataController.add(this);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
