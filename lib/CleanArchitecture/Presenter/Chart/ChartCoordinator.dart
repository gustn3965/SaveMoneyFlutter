import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

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

    void showToastChart(GroupChartToastModel toastModel) {
      showToastYChart(toastModel.categoryName, toastModel.categoryMoney,
          toastModel.totalMoney, toastModel.dateString);
    }

    GroupMonthChartActions action =
        GroupMonthChartActions(updateSelectedGroupCategorys, showToastChart);

    groupMonthChartViewModel =
        appDIContainer.chart.makeGroupMonthChartViewModel(action);

    return appDIContainer.chart
        .makeGroupMonthChartWidget(groupMonthChartViewModel!);
  }

  Widget makeSpendCategoryChartWidget() {
    void showToastChart(SpendChartToastModel toastModel) {
      showToastYChart(toastModel.categoryName, toastModel.categoryMoney,
          toastModel.totalMoney, toastModel.dateString);
    }

    SpendCategoryChartActions action =
        SpendCategoryChartActions(showToastChart);

    spendCategoryChartViewModel =
        appDIContainer.chart.makeSpendCategoryChartViewModel(action);

    return appDIContainer.chart
        .makeSpendCategoryChartWidget(spendCategoryChartViewModel!);
  }

  @override
  void updateCurrentWidget() {
    groupMonthChartViewModel?.reloadFetch();
    spendCategoryChartViewModel?.reloadFetch();
    // TODO: implement updateCurrentWidget
  }

  void showToastYChart(
      String name, int money, int totalMoney, String dateString) {
    Fluttertoast.showToast(
        msg:
            '${dateString} \n${name} : ${NumberFormat("#,###").format(money)}원 \n\n총비용 : ${NumberFormat("#,###").format(totalMoney)}원',
        //메세지입력
        toastLength: Toast.LENGTH_SHORT,
        //메세지를 보여주는 시간(길이)
        gravity: ToastGravity.CENTER,
        //위치지정
        timeInSecForIosWeb: 1,
        //ios및웹용 시간
        backgroundColor: AppColors.lightDarkColor,
        //배경색
        textColor: appColors.whiteColor(),
        //글자색
        fontSize: 16.0 //폰트사이즈
        );
  }
}
