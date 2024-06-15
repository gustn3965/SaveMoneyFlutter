import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../../Extension/Color+Extension.dart';
import '../../../../../Extension/DateTime+Extension.dart';
import '../../../AppCoordinator.dart';
import '../ViewModel/SpendCategoryChartViewModel.dart';

class SpendCategoryChartWidget extends StatelessWidget {
  final SpendCategoryChartViewModel viewModel;

  SpendCategoryChartWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<SpendCategoryChartViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width:
                  MediaQuery.of(NavigationService.currentContext!).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Container(
                  child: Column(
                    children: [
                      headerTitleWidget(),
                      SizedBox(height: 15),
                      spendCategorySelectorWidget(),
                      SizedBox(height: 15),
                      makeBarChart(),
                    ],
                  ),
                ),
              ),
            );
          },
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
                    '소비 카테고리 차트',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 40), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
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

  Widget spendCategorySelectorWidget() {
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

  _makeChipButton(SpendCategoryChartViewModel viewModel) {
    List<dynamic> chipArray = [];
    for (var groupObject in viewModel.spendCategorySelectorItems) {
      chipArray.add(spendCategoryChip(groupObject));
    }
    return chipArray;
  }

  spendCategoryChip(SpendCategoryChartSelectorItem item) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: FilterChip(
          showCheckmark: false,
          selected: viewModel.selectedSpendCategorySelectorItems.contains(item),
          backgroundColor: AppColors.whiteColor,
          selectedColor: generateUniqueColor(item.categoryIdentity),
          // shadowColor: Colors.grey,
          // elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          label: Text("# ${item.categoryName}"),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(strokeAlign: 0.5),
          onSelected: (bool value) async {
            viewModel.didSelectSpendCategory(item);
          }),
    );
  }

  Widget makeBarChart() {
    if (viewModel.chartModel == null || viewModel.chartModel!.xModels.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
            child: Text(
          '선택한 소비 카테고리가 없습니다. \n(선택해주세요)',
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

  BarChartData mainBarData(SpendChartModel chartModel) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.black,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -100,
          direction: TooltipDirection.bottom,
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
        '${DateFormat('yy년\nM월').format(dateTimeFromSince1970(value.toInt()))}',
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  List<BarChartGroupData> showingGroups(SpendChartModel chartModel) =>
      List.generate(chartModel.xModels.length, (i) {
        SpendChartXModel xModel = chartModel.xModels[i];
        return makeGroup(xModel);
      });

  BarChartGroupData makeGroup(SpendChartXModel xModel) {
    double fromY = 0;
    return BarChartGroupData(
      x: xModel.xIndex,
      groupVertically: true,
      barRods: List.generate(xModel.yModels.length, (i) {
        SpendChartYModel yModel = xModel.yModels[i];
        double price = yModel.yIndex.toDouble();
        Color barColor = generateUniqueColor(yModel.spendCategoryId);
        BarChartRodData chartRodData = BarChartRodData(
          fromY: fromY,
          toY: fromY + price,
          color: barColor,
          width: 22,
          borderRadius: BorderRadius.zero,
        );

        fromY = fromY + price + (2000);
        return chartRodData;
      }),
    );
  }
}
