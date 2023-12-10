import 'dart:async';
import 'dart:math';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../view_model/save_money_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MonthSpendListBarChart extends StatefulWidget {
  MonthSpendListBarChart({super.key});

  List<Color> get availableColors => const <Color>[
        Colors.white,
        Colors.white70,
        Colors.white38,
        Colors.white24,
        Colors.white10,
        Colors.white12,
      ];

  final Color barBackgroundColor = Colors.blue.withOpacity(0.3);
  final Color barColor = Colors.black38;
  final Color touchedBarColor = Colors.brown;

  @override
  State<StatefulWidget> createState() => MonthSpendListBarChartState();
}

class MonthSpendListBarChartState extends State<MonthSpendListBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  late SaveMoneyViewModel saveMoneyViewModel;

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);
    if (saveMoneyViewModel.monthSpendModels.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width:
                (30 * saveMoneyViewModel.monthSpendModels.length).toDouble() +
                    80,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: BarChart(
                  mainBarData(saveMoneyViewModel),
                  swapAnimationDuration: animDuration,
                ),
              ),
            ),
          ));
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.blueAccent : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: Colors.transparent,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(saveMoneyViewModel.monthSpendModels.length, (i) {
        int price = saveMoneyViewModel.monthSpendModels[i].price;
        return makeGroupData(
          i,
          price == 0 ? 1 : price.toDouble(),
          isTouched: this.touchedIndex == i,
          barColor: saveMoneyViewModel.monthSpendModels[i].color,
        );
      });

  BarChartData mainBarData(SaveMoneyViewModel saveMoneyViewModel) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.black,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String categoryName =
                saveMoneyViewModel.monthSpendModels[groupIndex].categoryName;
            int price = saveMoneyViewModel.monthSpendModels[groupIndex].price;
            return BarTooltipItem(
              '$categoryName\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${NumberFormat("#,###").format(price)}원',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
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
            showTitles: false,
            getTitlesWidget: getTitles,
            reservedSize: 38,
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
      barGroups: showingGroups(),
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

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
