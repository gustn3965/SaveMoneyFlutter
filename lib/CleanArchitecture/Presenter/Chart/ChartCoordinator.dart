import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/DIContainer/AppDIContainer.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/Widget/GroupMonthChartWidget.dart';
import 'package:save_money_flutter/main.dart';

import 'ChartWidget.dart';
import 'GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';
import 'SpendCategoryChart/ViewModel/SpendCategoryChartViewModel.dart';

class ChartCoordinator extends Coordinator {
  GroupMonthChartViewModel? groupMonthChartViewModel;
  SpendCategoryChartViewModel? spendCategoryChartViewModel;

  ChartCoordinator(Coordinator superCoordinator)
      : super(superCoordinator, null) {
    Widget groupMonthChartWidget = makeGroupMonthChartWidget();
    Widget spendCategoryChartWidget = makeSpendCategoryChartWidget();
    Widget emptyBottomWidget = const SizedBox(height: 100);
    routeName = "chartTab";
    currentWidget = ChartWidget(widgets: [
      groupMonthChartWidget,
      spendCategoryChartWidget,
      emptyBottomWidget,
    ]);
  }

  Widget makeGroupMonthChartWidget() {
    void updateSelectedGroupCategorys(List<String> selectedGroupCategorys) {
      spendCategoryChartViewModel
          ?.fetchSpendCategoryList(selectedGroupCategorys);
    }

    GroupMonthChartActions action =
        GroupMonthChartActions(updateSelectedGroupCategorys);

    groupMonthChartViewModel =
        appDIContainer.chart.makeGroupMonthChartViewModel(action);

    return appDIContainer.chart
        .makeGroupMonthChartWidget(groupMonthChartViewModel!);
  }

  Widget makeSpendCategoryChartWidget() {
    spendCategoryChartViewModel =
        appDIContainer.chart.makeSpendCategoryChartViewModel();

    return appDIContainer.chart
        .makeSpendCategoryChartWidget(spendCategoryChartViewModel!);
  }

  @override
  void updateCurrentWidget() {
    groupMonthChartViewModel?.reloadFetch();
    spendCategoryChartViewModel?.reloadFetch();
    // TODO: implement updateCurrentWidget
  }
}
