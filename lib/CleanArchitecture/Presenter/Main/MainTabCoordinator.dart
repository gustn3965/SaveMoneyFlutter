import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/ChartCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/HomeCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/HomeWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SettingsCoordinator.dart';

import 'package:save_money_flutter/main.dart';
import '../../Domain/Entity/GroupMonth.dart';
import '../AppCoordinator.dart';

import 'MainTabWidget.dart';

class MainTabCoordinator extends Coordinator {
  late HomeCoordinator homeCoordinator;
  late ChartCoordinator chartCoordinator;
  late SettingsCoordinator settingsCoordinator;

  MainTabViewModel? mainHomeViewModel;

  MainTabCoordinator(Coordinator? superCoordinator)
      : super(superCoordinator, null) {
    routeName = "MainHome";
    homeCoordinator = HomeCoordinator(this);
    homeCoordinator.routeName = this.routeName;
    chartCoordinator = ChartCoordinator(this);
    settingsCoordinator = SettingsCoordinator(this);
    currentWidget = makeMainHomeWidget();
  }

  @override
  void pop() {
    print("MainHome Pop");
    // TODO: implement pop
  }

  @override
  void start() {
    super.start();
    // TODO: implement start
  }

  @override
  void updateCurrentWidget() {
    homeCoordinator.updateCurrentWidget();
    chartCoordinator.updateCurrentWidget();
    settingsCoordinator.updateCurrentWidget();
  }

  Widget makeMainHomeWidget() {
    void didClickHomeTab() {
      if (currentWidget is MainTabWidget) {
        MainTabWidget mainTabWidget = currentWidget as MainTabWidget;
        mainTabWidget.bodyWidget = homeCoordinator.currentWidget;
      }
    }

    void didClickChartTab() {
      if (currentWidget is MainTabWidget) {
        MainTabWidget mainTabWidget = currentWidget as MainTabWidget;
        mainTabWidget.bodyWidget = chartCoordinator.currentWidget;
      }
    }

    void didClickSettingTab() {
      if (currentWidget is MainTabWidget) {
        MainTabWidget mainTabWidget = currentWidget as MainTabWidget;
        mainTabWidget.bodyWidget = settingsCoordinator.currentWidget;
      }
    }

    MainTabViewModelAction action = MainTabViewModelAction(
      didClickHomeTab,
      didClickChartTab,
      didClickSettingTab,
    );

    mainHomeViewModel = appDIContainer.mainTab.makeMainHomeViewModel(action);

    return appDIContainer.mainTab
        .makeMainHomeWidget(mainHomeViewModel!, homeCoordinator.currentWidget);
  }

  //------------------------------------------------------------
  // 테스트용으로 AppStatus 변경했을떄.
  void resetMainTabChildCoordinators() {
    homeCoordinator = HomeCoordinator(this);
    chartCoordinator = ChartCoordinator(this);
    settingsCoordinator = SettingsCoordinator(this);
  }
}
