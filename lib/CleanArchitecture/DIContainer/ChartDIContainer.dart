import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/ViewModel/DefaultGroupMonthChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/Widget/GroupMonthChartWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/DefaultSpendCategoryChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/SpendCategoryChartViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/Widget/SpendCategoryChartWidget.dart';

import '../Presenter/Chart/GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';

class ChartDIContainer {
  AppStatus appStatus;

  ChartDIContainer(this.appStatus);

  // Chart - GroupMonth
  GroupMonthChartViewModel makeGroupMonthChartViewModel() {
    return DefaultGroupMonthChartViewModel();
  }

  Widget makeGroupMonthChartWidget(GroupMonthChartViewModel viewModel) {
    return GroupMonthChartWidget(viewModel);
  }

  // Chart - SpendCategory
  SpendCategoryChartViewModel makeSpendCategoryChartViewModel() {
    return DefaultSpendCategoryChartViewModel();
  }

  Widget makeSpendCategoryChartWidget(SpendCategoryChartViewModel viewModel) {
    return SpendCategoryChartWidget(viewModel);
  }
}
