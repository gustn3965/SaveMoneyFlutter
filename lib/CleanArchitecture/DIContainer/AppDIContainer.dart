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
  db,
}

// TODO: - appStatus에 따라 다르게 주입해주기 ( Widget, ViewModel, UseCase )
class AppDIContainer {
  AppStatus appStatus; // main.dart

  AppDIContainer({required this.appStatus}) {
    // 우선은... 나중에 아래 switch구문으로 해야함, 타겟별로 새로 설치할거므로.
    MockDataSet().setupMockGroupMonth();

    switch (appStatus) {
      case AppStatus.mock:
        // MockDataSet().setupMockGroupMonth();
        break;
      case AppStatus.db:
        break;
    }
  }

  late Repository repository = Repository(SQLiteDataBase(), null);

  late LoginDIContainer login = LoginDIContainer(this.appStatus);

  late MainTabDIContainer mainTab = MainTabDIContainer(this.appStatus);

  late HomeDIContainer home = HomeDIContainer(this.appStatus);

  late AddSpendDIContainer addSpend = AddSpendDIContainer(this.appStatus);

  late EditSpendDIContainer editSpend = EditSpendDIContainer(this.appStatus);

  late AddGroupDIContainer addGroup = AddGroupDIContainer(this.appStatus);

  late SettingsDIContainer settings = SettingsDIContainer(this.appStatus);

  late ChartDIContainer chart = ChartDIContainer(this.appStatus);

  late AddSpendCategoryDIContainer addSpendCategory =
      AddSpendCategoryDIContainer(this.appStatus);

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
