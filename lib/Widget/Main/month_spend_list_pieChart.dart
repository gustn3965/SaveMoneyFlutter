import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../view_model/Model/MonthSpendModel.dart';
import '../../view_model/save_money_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  late SaveMoneyViewModel saveMoneyViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);

    if (saveMoneyViewModel.monthSpendModels.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      int totalSpendMoney = 0;
      for (MonthSpendModel model in saveMoneyViewModel.monthSpendModels) {
        totalSpendMoney += model.price;
      }
      return Column(
        children: [
          Text('${NumberFormat("#,###").format(totalSpendMoney)}원',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                height: 0,
              )),
          Text(
              '${DateFormat('yyyy년 MM').format(saveMoneyViewModel.focusedDay)}월 내역',
              style: const TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                height: 0,
              )),
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 5,
                      centerSpaceRadius: 50,
                      startDegreeOffset: 270,
                      sections: showingSections(saveMoneyViewModel),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: makeIndicatorWidget(saveMoneyViewModel),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ],
      );
    }
  }

  List<Indicator> makeIndicatorWidget(SaveMoneyViewModel saveMoneyViewModel) {
    return saveMoneyViewModel.monthSpendModels
        .map((e) =>
            Indicator(color: e.color, text: e.categoryName, isSquare: true))
        .toList();
  }

  List<PieChartSectionData> showingSections(
      SaveMoneyViewModel saveMoneyViewModel) {
    return List.generate(saveMoneyViewModel.monthSpendModels.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 70.0 : 50.0;
      int title = saveMoneyViewModel.monthSpendModels[i].price;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
          color: saveMoneyViewModel.monthSpendModels[i].color,
          value: saveMoneyViewModel.monthSpendModels[i].price.toDouble(),
          title: isTouched ? '${NumberFormat("#,###").format(title)}원' : '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titlePositionPercentageOffset: -1);
    });
  }
}

class Indicator extends StatelessWidget {
  Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
