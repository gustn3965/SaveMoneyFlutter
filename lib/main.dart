import 'package:flutter/material.dart';
import 'package:save_money_flutter/top_will_save_money_widget.dart';
import 'package:save_money_flutter/top_group_will_spend_money_widget.dart';
import 'spend_group_widget.dart';

import 'calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int money = 100000;
  int willSpendMoney = 1000000;

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final moneyFormatted = NumberFormat("#,###").format(money);
    final willSpendMoneyFormatted = NumberFormat("#,###").format(willSpendMoney);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA6BDFA),
        title: GestureDetector(
          onTap: () {
            _showYearMonthDatePicker(context);
          },
          child: Text(
            DateFormat('yyyy-MM').format(selectedDate),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopWillSaveMoneyWidget(
              firstText: '+ $moneyFormatted',
              secondText: '돈을 모을 예정이에요. 👍',
            ),
            TopGroupWillSpendMoneyWidget(
              rightText: '$willSpendMoneyFormatted'
            ),
            SpendGroupWidget(),
            MyCalendarPage(),
            SizedBox(height: 70),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clickButton,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void clickButton() {
    setState(() {
      money += 1000000;
    });
  }

  // 년월 달력을 표시하는 메서드
  Future<void> _showYearMonthDatePicker(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: this.selectedDate,
      firstDate: DateTime(2000), // 시작 년도
      lastDate: DateTime(2101),  // 마지막 년도
initialDatePickerMode: DatePickerMode.year,
      builder: (BuildContext context, Widget? child) {
        return Builder(
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData.light(), // 년월만 선택 가능한 디자인
              child: child!,
            );
          },
        );
      },
    );

    if (selectedDate != null && selectedDate != this.selectedDate) {
      setState(() {
        print(selectedDate);
        this.selectedDate = selectedDate;
      });
    }
  }
}
