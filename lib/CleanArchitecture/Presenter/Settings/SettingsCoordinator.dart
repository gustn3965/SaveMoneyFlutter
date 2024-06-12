import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/ViewModel/SettingsViewModel.dart';
import 'package:save_money_flutter/main.dart';

class SettingsCoordinator extends Coordinator {
  SettingsViewModel? settingsViewModel;

  SettingsCoordinator(Coordinator superCoordinator) : super(superCoordinator) {
    void moveToLoginWidget() {
      pop();
      LoginCoordinator loginCoordinator = LoginCoordinator(appCoordinator);
      loginCoordinator.start();
    }

    void clickChangeAppStatus() {
      if (superCoordinator is MainTabCoordinator) {
        superCoordinator.resetMainTabChildCoordinators();
      }
    }

    SettingsAction action = SettingsAction(
      moveToLoginWidget,
      clickChangeAppStatus,
    );

    settingsViewModel = appDIContainer.settings.makeSettingsViewModel(action);
    currentWidget =
        appDIContainer.settings.makeSettingsWidget(settingsViewModel!);
  }

  @override
  void start() {
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => currentWidget,
      ),
    );
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }
}
