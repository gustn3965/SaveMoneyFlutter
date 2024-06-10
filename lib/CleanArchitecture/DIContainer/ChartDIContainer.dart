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
    return DefaultGroupMonthChartViewModel(
        action,
        RepoGroupCategoryFetchUseCase(appDIContainer.repository),
        RepoGroupMonthFetchUseCase(appDIContainer.repository));
  }

  Widget makeGroupMonthChartWidget(GroupMonthChartViewModel viewModel) {
    return GroupMonthChartWidget(viewModel);
  }

  // Chart - SpendCategory
  SpendCategoryChartViewModel makeSpendCategoryChartViewModel() {
    return DefaultSpendCategoryChartViewModel(
        RepoSpendCategoryFetchUseCase(appDIContainer.repository),
        RepoSpendListUseCase(appDIContainer.repository));
  }

  Widget makeSpendCategoryChartWidget(SpendCategoryChartViewModel viewModel) {
    return SpendCategoryChartWidget(viewModel);
  }
}
