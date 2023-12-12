import 'dart:async';
import 'dart:math';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../view_model/Model/MonthSpendModel.dart';
import '../../../../view_model/save_money_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'month_spend_list_barChart.dart';
import '../../Chart/month/month_spend_list_pieChart.dart';

class MonthSpendListGraphChart extends StatefulWidget {
  const MonthSpendListGraphChart({super.key});

  @override
  State<MonthSpendListGraphChart> createState() =>
      _MonthSpendListGraphChartState();
}

class _MonthSpendListGraphChartState extends State<MonthSpendListGraphChart> {
  late SaveMoneyViewModel saveMoneyViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);
    int totalSpendMoney = 0;
    for (MonthSpendModel model in saveMoneyViewModel.monthSpendModels) {
      totalSpendMoney += model.price;
    }

    if (saveMoneyViewModel.monthSpendModels.length == 0) {
      return Column(
        children: [
          headerWidget(totalSpendMoney),
          SizedBox(height: 40),
        ],
      );
    } else {
      return Column(
        children: [
          headerWidget(totalSpendMoney),
          MonthSpendListBarChart(),
          MonthSpendListPieChart(),
          SizedBox(height: 40),
        ],
      );
    }
    return const Placeholder();
  }

  Widget headerWidget(int totalSpend) {
    return Container(
      // height: 65,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFE5E3E3),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 40, right: 10), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '${saveMoneyViewModel.focusedDay?.month}월 요약 차트',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 40),
                  child: Text(
                    totalSpend == 0
                        ? '소비된 내역이 없습니다.'
                        : '${NumberFormat("#,###").format(totalSpend)}원',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
