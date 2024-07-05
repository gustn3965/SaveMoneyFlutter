

import 'package:flutter/widgets.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppGuide/ViewModel/AppGuideViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppGuide/Widget/AppGuideWidget.dart';

import '../AppCoordinator.dart';

class AppGuideCoordinator extends Coordinator {
  AppGuideViewModel? appGuideViewModel;

  AppGuideCoordinator(
      {required Coordinator superCoordinator,
        required Coordinator parentTabCoordinator,
        required Function() showNextWidget})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "AppGuideWidget";
    currentWidget = makeAppGuideWidget(showNextWidget);
  }

  @override
  void updateCurrentWidget() {
    appGuideViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }



  Widget makeAppGuideWidget(Function() showNextWidget) {
    void clickToNextWidget() {
      pop();
      showNextWidget();
    }

    AppGuideAction action = AppGuideAction(clickStart: clickToNextWidget);

    appGuideViewModel = AppGuideViewModel(action);
    return AppGuideWidget(appGuideViewModel!);
  }
}
