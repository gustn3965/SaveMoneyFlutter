import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Login/LoginCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/AppNotice/AppNoticeWebCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryListCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/UserFeedback/UserFeedbackWebCoordinator.dart';
import 'package:save_money_flutter/main.dart';

import '../AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';
import 'GroupCategoryListCoordinator.dart';
import 'Setting/ViewModel/SettingsViewModel.dart';

class SettingsCoordinator extends Coordinator {
  SettingsViewModel? settingsViewModel;

  SettingsCoordinator(Coordinator superCoordinator)
      : super(superCoordinator, null) {
    routeName = "Settings";
    currentWidget = makeSettingWidget();
  }

  @override
  void updateCurrentWidget() {
    settingsViewModel?.reloadData();

    for (Coordinator child in childCoordinator) {
      child.updateCurrentWidget();
    }
  }

  Widget makeSettingWidget() {
    void moveToLoginWidget() {
      LoginCoordinator loginCoordinator = LoginCoordinator(appCoordinator);
      loginCoordinator.startOnFirstNavigation();
    }

    void moveToSpendCategoryList() {
      SpendCategoryListCoordinator spendCategoryListCoordinator =
          SpendCategoryListCoordinator(
              superCoordinator: this, parentTabCoordinator: this);
      spendCategoryListCoordinator.start();
    }

    void moveToGroupCategoryList() {
      GroupCategoryListCoordinator groupCategoryListCoordinator =
          GroupCategoryListCoordinator(
              superCoordinator: this, parentTabCoordinator: this);
      groupCategoryListCoordinator.start();
    }

    void showAppNotice() {
      AppNoticeWebCoordinator appNoticeCoordinator = AppNoticeWebCoordinator(superCoordinator: this, parentTabCoordinator: this);
      appNoticeCoordinator.start();
    }

    void showUserFeedback() {
      UserFeedbackWebCoordinator userFeedbackWebCoordinator = UserFeedbackWebCoordinator(superCoordinator: this, parentTabCoordinator: this);
      userFeedbackWebCoordinator.start();
    }

    void didAllDelteDataSet() async {
      await appDIContainer.repository.deleteAllDataSet();
      triggerTopUpdateWidget();
    }

    SettingsAction action = SettingsAction(
        clickToMoveLogin: moveToLoginWidget,
        clickToMoveSpendCategorys: moveToSpendCategoryList,
        clickToMoveGroupCategorys: moveToGroupCategoryList,
        clickToShowAppNotice: showAppNotice,
        clickToShowUserFeedback: showUserFeedback,
        clickAllDeleteTableDataSet: didAllDelteDataSet);

    settingsViewModel = appDIContainer.settings.makeSettingsViewModel(action);
    return appDIContainer.settings.makeSettingsWidget(settingsViewModel!);
  }
}
