import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/ViewModel/SettingsViewModel.dart';
import 'package:save_money_flutter/main.dart';

class SettingsCoordinator extends Coordinator {
  SettingsViewModel? settingsViewModel;

  SettingsCoordinator(Coordinator superCoordinator) : super(superCoordinator) {
    settingsViewModel = appDIContainer.settings.makeSettingsViewModel();
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
