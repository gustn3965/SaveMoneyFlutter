
import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/main.dart';

class AppNoticeWebViewAction {
  void Function() navigationPop;

  AppNoticeWebViewAction(
      {required this.navigationPop});
}

class AppNoticeWebViewModel {

  AppNoticeWebViewAction action;
  String noticeUrl = "";

  AppNoticeWebViewModel(this.action) {
    noticeUrl = "https://gustn3965.github.io/saveMoneyNotice/";
    if (appDIContainer.appOS == AppOS.ios) {
      noticeUrl += "ios.html";
    } else if (appDIContainer.appStatus == AppOS.android) {
      noticeUrl += "android";
    }
  }

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