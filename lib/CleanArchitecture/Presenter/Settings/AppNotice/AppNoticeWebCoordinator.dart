import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/main.dart';
import '../../AppCoordinator.dart';
import 'ViewModel/AppNoticeViewModel.dart';
import 'Widget/AppNoticeWebView.dart';

class AppNoticeWebCoordinator extends Coordinator {
  AppNoticeWebViewModel? appNoticeWebViewModel;

  AppNoticeWebCoordinator(
      {required Coordinator superCoordinator,
      required Coordinator parentTabCoordinator})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "AppNoticeWebView";
    currentWidget = makeAppNoticeWebView();
  }

  @override
  void updateCurrentWidget() {
    appNoticeWebViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeAppNoticeWebView() {

    void navigationPop() {
      pop();
    }

    AppNoticeWebViewAction action = AppNoticeWebViewAction(
        navigationPop: navigationPop);
    appNoticeWebViewModel = appDIContainer.settings.makeAppNoticeWebViewModel(action);
    return appDIContainer.settings.makeAppNoticeWebView(appNoticeWebViewModel!);
  }
}
