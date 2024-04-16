import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
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
  late SettingsCoordinator settingsCoordinator;

  MainTabViewModel? mainHomeViewModel;

  MainTabCoordinator(Coordinator? superCoordinator) : super(superCoordinator) {
    routeName = "MainHome";
    homeCoordinator = HomeCoordinator(this);
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
    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => currentWidget,
      ),
    );
    homeCoordinator.routeName = this.routeName;
    // TODO: implement start
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeMainHomeWidget() {
    void didClickHomeTab() {
      if (currentWidget is MainTabWidget) {
        MainTabWidget mainTabWidget = currentWidget as MainTabWidget;
        mainTabWidget.bodyWidget = homeCoordinator.currentWidget;
      }
      print("click Home");
    }

    void didClickSettingTab() {
      if (currentWidget is MainTabWidget) {
        MainTabWidget mainTabWidget = currentWidget as MainTabWidget;
        mainTabWidget.bodyWidget = settingsCoordinator.currentWidget;
      }
      print("clickSetting");
    }

    MainTabViewModelAction action = MainTabViewModelAction(
      didClickHomeTab,
      didClickSettingTab,
    );

    mainHomeViewModel = appDIContainer.mainTab.makeMainHomeViewModel(action);

    return appDIContainer.mainTab
        .makeMainHomeWidget(mainHomeViewModel!, homeCoordinator.currentWidget);
  }
}
