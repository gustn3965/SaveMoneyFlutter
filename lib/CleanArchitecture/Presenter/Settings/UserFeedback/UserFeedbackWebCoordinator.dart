import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/UserFeedback/ViewModel/UserFeedbackWebViewModel.dart';
import 'package:save_money_flutter/main.dart';
import '../../AppCoordinator.dart';

class UserFeedbackWebCoordinator extends Coordinator {
  UserFeedbackWebViewModel? userFeedbackWebViewModel;

  UserFeedbackWebCoordinator(
      {required Coordinator superCoordinator,
        required Coordinator parentTabCoordinator})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "AppNoticeWebView";
    currentWidget = makeAppNoticeWebView();
  }

  @override
  void updateCurrentWidget() {
    userFeedbackWebViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeAppNoticeWebView() {

    void navigationPop() {
      pop();
    }

    UserFeedbackWebViewAction action = UserFeedbackWebViewAction(
        navigationPop: navigationPop);
    userFeedbackWebViewModel = appDIContainer.settings.makeUserFeedbackWebViewModel(action);
    return appDIContainer.settings.makeUserFeedbackWebView(userFeedbackWebViewModel!);
  }
}
