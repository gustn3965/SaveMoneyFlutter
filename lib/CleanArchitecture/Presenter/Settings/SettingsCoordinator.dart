import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';
import 'package:save_money_flutter/main.dart';

import 'Setting/ViewModel/SettingsViewModel.dart';

class SettingsCoordinator extends Coordinator {
  SettingsViewModel? settingsViewModel;
  SpendCategoryListViewModel? spendCategoryListViewModel;

  SettingsCoordinator(Coordinator superCoordinator) : super(superCoordinator) {
    currentWidget = makeSettingWidget();
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

  Widget makeSettingWidget() {
    void moveToLoginWidget() {
      pop();
      LoginCoordinator loginCoordinator = LoginCoordinator(appCoordinator);
      loginCoordinator.start();
    }

    void moveToSpendCategoryList() {
      NavigationService.navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => makeSpendCategoryListWidget(),
        ),
      );
    }

    void clickChangeAppStatus() {
      if (superCoordinator is MainTabCoordinator) {
        (superCoordinator as MainTabCoordinator)
            ?.resetMainTabChildCoordinators();
      }
    }

    SettingsAction action = SettingsAction(
        clickToMoveLogin: moveToLoginWidget,
        clickToMoveSpendCategorys: moveToSpendCategoryList,
        clickChangeAppStatus: clickChangeAppStatus);

    settingsViewModel = appDIContainer.settings.makeSettingsViewModel(action);
    return appDIContainer.settings.makeSettingsWidget(settingsViewModel!);
  }

  Widget makeSpendCategoryListWidget() {
    void showEditSpendCategory(String spendCategoryId) {
      print("edit....");
    }

    void showAddSpendCategory() {
      print("add...");
    }

    SpendCategoryListAction action = SpendCategoryListAction(
        showEditSpendCategoryWidget: showEditSpendCategory,
        showAddSpendCategoryWidget: showAddSpendCategory);

    spendCategoryListViewModel =
        appDIContainer.settings.makeSpendCategoryListViewModel(action);

    return appDIContainer.settings
        .makeSpendCategoryListWidget(spendCategoryListViewModel!);
  }
}
