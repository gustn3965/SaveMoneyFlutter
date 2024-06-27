import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';

import '../../../../../AppColor/AppColors.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../../Extension/Color+Extension.dart';
import '../../../../../Extension/DateTime+Extension.dart';
import '../../../AppCoordinator.dart';

class GroupMonthChartWidget extends StatefulWidget {
  final GroupMonthChartViewModel viewModel;

  GroupMonthChartWidget(this.viewModel);

  _GroupMonthChartState createState() => _GroupMonthChartState();
}
class _GroupMonthChartState extends State<GroupMonthChartWidget> {
  late GroupMonthChartViewModel viewModel = widget.viewModel;

  int? touchedGroupIndex;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<GroupMonthChartViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Container(
          width: MediaQuery.of(NavigationService.currentContext!).size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Container(
              child: Column(
                children: [
                  headerTitleWidget(),
                  SizedBox(height: 15),
                  groupCategorySelectorWidget(),
                  SizedBox(height: 15),
                  makeBarChart(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget headerTitleWidget() {
    return Container(
      color: const Color(0xFFE5E3E3),
      child: const Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '지출그룹 차트',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget groupCategorySelectorWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10.0,
        runSpacing: 10.0,
        children: <Widget>[..._makeChipButton(viewModel)],
      ),
    );
  }

  _makeChipButton(GroupMonthChartViewModel viewModel) {
    List<dynamic> chipArray = [];
    for (var groupObject in viewModel.groupCategorySelectorItems) {
      chipArray.add(_groupCategoryChip(groupObject, viewModel));
    }
    return chipArray;
  }

  _groupCategoryChip(GroupCategoryChartSelectorItem groupObject,
      GroupMonthChartViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: FilterChip(
        showCheckmark: false,
        selected:
            viewModel.selectedGroupCategorySelectorItems.contains(groupObject),
        backgroundColor: Colors.white,
        selectedColor: AppColors.mainRedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text("${groupObject.categoryName}"),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(width: 1),
        onSelected: (bool value) async {
          viewModel.didSelectGroupCategory(groupObject);
        },
      ),
    );
  }

  Widget makeBarChart() {
    if (viewModel.chartModel == null || viewModel.chartModel!.xModels.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
            child: Text(
          '선택한 지출 그룹이 없습니다.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        )),
      );
    } else {
      double width =
          (30 * viewModel.chartModel!.xModels.length).toDouble() + 80;
      double defaultWidth =
          MediaQuery.of(NavigationService.navigatorKey.currentContext!)
              .size
              .width;
      if (width < defaultWidth) {
        width = defaultWidth;
      }
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: AspectRatio(
                aspectRatio: 2.0,
                child: BarChart(
                  mainBarData(viewModel.chartModel!),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
            ),
          ));
    }
  }

  BarChartData mainBarData(GroupChartModel chartModel) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
          if (response != null && response.spot != null) {

            int xIndex = response.spot!.touchedBarGroupIndex;
            int yIndex = response.spot!.touchedRodDataIndex;
            GroupChartYModel yModel = chartModel.xModels[xIndex].yModels[yIndex];

            setState(() {
              touchedGroupIndex = xIndex;
            });

            if (event is FlTapDownEvent || event is FlLongPressMoveUpdate) {
              viewModel.clickChart(xIndex: xIndex, yIndex: yIndex);
            }
          }
        },
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
        ),

      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 50,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 60,
          ),
          axisNameSize: 60,
        ),
      ), // 우측,탑 바텀 레이블
      borderData: FlBorderData(
        show: false,
      ), // 차트 바깥
      barGroups: showingGroups(chartModel),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text('${NumberFormat.compact(locale: 'ko').format(value)}'),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        '${DateFormat('yy년\nM월').format(dateTimeFromSince1970(value.toInt() * 1000))}',
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  List<BarChartGroupData> showingGroups(GroupChartModel chartModel) =>
      List.generate(chartModel.xModels.length, (i) {
        GroupChartXModel xModel = chartModel.xModels[i];
        return makeGroup(xModel);
      });

  BarChartGroupData makeGroup(GroupChartXModel xModel) {
    double fromY = 0;
    bool isTouched = touchedGroupIndex != null && viewModel.chartModel?.xModels[touchedGroupIndex!].xIndex == xModel.xIndex;
    return BarChartGroupData(
      x: xModel.xIndex,
      groupVertically: true,
      barRods: List.generate(xModel.yModels.length, (i) {
        GroupChartYModel yModel = xModel.yModels[i];
        double price = yModel.yIndex.toDouble();
        Color barColor = generateUniqueColor(yModel.groupCategoryId);
        BarChartRodData chartRodData = BarChartRodData(
          fromY: fromY,
          toY: fromY + price + (isTouched ? (fromY + price) / 10 : 0),
          color: isTouched ? darkColor(barColor) : barColor,
          width: 22 + (isTouched ? 7 : 0),
          borderRadius: BorderRadius.zero,
        );

        fromY = fromY + price + 2000;
        return chartRodData;
      }),
    );
  }
}
