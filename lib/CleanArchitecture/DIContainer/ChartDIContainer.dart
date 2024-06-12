import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/ViewModel/DefaultGroupMonthChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/Widget/GroupMonthChartWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/DefaultSpendCategoryChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/SpendCategoryChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/Widget/SpendCategoryChartWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupMonthFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendCategoryFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendListUseCase.dart';

import '../../main.dart';
import '../Presenter/Chart/GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';

class ChartDIContainer {
  AppStatus appStatus;

  ChartDIContainer(this.appStatus);

  // Chart - GroupMonth
  GroupMonthChartViewModel makeGroupMonthChartViewModel(
      GroupMonthChartActions action) {
    GroupCategoryFetchUseCase groupCategoryFetchUseCase;
    GroupMonthFetchUseCase groupMonthFetchUseCase;
    switch (appStatus) {
      case AppStatus.db:
        groupCategoryFetchUseCase =
            RepoGroupCategoryFetchUseCase(appDIContainer.repository);
        groupMonthFetchUseCase =
            RepoGroupMonthFetchUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        groupCategoryFetchUseCase = MockGroupCategoryFetchUseCase();
        groupMonthFetchUseCase = MockGroupMonthFetchUseCase();
        break;
    }

    return DefaultGroupMonthChartViewModel(
        action, groupCategoryFetchUseCase, groupMonthFetchUseCase);
  }

  Widget makeGroupMonthChartWidget(GroupMonthChartViewModel viewModel) {
    return GroupMonthChartWidget(viewModel);
  }

  // Chart - SpendCategory
  SpendCategoryChartViewModel makeSpendCategoryChartViewModel() {
    SpendCategoryFetchUseCase spendCategoryFetchUseCase;
    SpendListUseCase spendListUseCase;
    switch (appStatus) {
      case AppStatus.db:
        spendCategoryFetchUseCase =
            RepoSpendCategoryFetchUseCase(appDIContainer.repository);
        spendListUseCase = RepoSpendListUseCase(appDIContainer.repository);
        break;
      case AppStatus.mock:
        spendCategoryFetchUseCase = MockSpendCategoryFetchUseCase();
        spendListUseCase = MockSpendListUseCase();
        break;
    }

    return DefaultSpendCategoryChartViewModel(
        spendCategoryFetchUseCase, spendListUseCase);
  }

  Widget makeSpendCategoryChartWidget(SpendCategoryChartViewModel viewModel) {
    return SpendCategoryChartWidget(viewModel);
  }
}
