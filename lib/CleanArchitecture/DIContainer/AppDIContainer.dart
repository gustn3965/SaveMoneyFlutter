import 'package:save_money_flutter/CleanArchitecture/DIContainer/ChartDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/SettingsDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

import '../Data/Repository/DataBase/SQLite/SQLiteDataBase.dart';
import 'AddSpendCategoryDIContainer.dart';
import 'EditSpendDIContainer.dart';
import 'HomeDIContainer.dart';
import 'LoginDIContainer.dart';
import 'MainTabDIContainer.dart';
import 'AddGroupDIContainer.dart';
import 'AddSpendDIContainer.dart';

enum AppStatus {
  mock,
  cbt,
  real,
}

// TODO: - appStatus에 따라 다르게 주입해주기 ( Widget, ViewModel, UseCase )
class AppDIContainer {
  AppStatus appStatus; // main.dart

  AppDIContainer({required this.appStatus}) {
    // 우선은... 나중에 아래 switch구문으로 해야함, 타겟별로 새로 설치할거므로.
    MockDataSet().setupMockGroupMonth();

    switch (appStatus) {
      case AppStatus.mock:
        MockDataSet().setupMockGroupMonth();
        break;
      case AppStatus.cbt:
        break;
      case AppStatus.real:
        break;
    }
  }

  late Repository repository = Repository(SQLiteDataBase(), null);

  late LoginDIContainer login = LoginDIContainer(appStatus);

  late MainTabDIContainer mainTab = MainTabDIContainer(appStatus);

  late HomeDIContainer home = HomeDIContainer(appStatus);

  late AddSpendDIContainer addSpend = AddSpendDIContainer(appStatus);

  late EditSpendDIContainer editSpend = EditSpendDIContainer(appStatus);

  late AddGroupDIContainer addGroup = AddGroupDIContainer(appStatus);

  late SettingsDIContainer settings = SettingsDIContainer(appStatus);

  late ChartDIContainer chart = ChartDIContainer(appStatus);

  late AddSpendCategoryDIContainer addSpendCategory =
      AddSpendCategoryDIContainer(appStatus);

  void changeAppStatus() {
    login.appStatus = appStatus;
    mainTab.appStatus = appStatus;
    home.appStatus = appStatus;
    addSpend.appStatus = appStatus;
    editSpend.appStatus = appStatus;
    addGroup.appStatus = appStatus;
    settings.appStatus = appStatus;
    chart.appStatus = appStatus;
    addSpendCategory.appStatus = appStatus;
  }
}
