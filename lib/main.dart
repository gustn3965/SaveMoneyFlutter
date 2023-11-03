import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'top_will_save_money_widget.dart';
import 'top_group_will_spend_money_widget.dart';
import 'spend_group_widget.dart';
import 'top_total_group_will_spend_money_widget.dart';
import 'add_spending_widget.dart';

import 'calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'view_model/save_money_view_model.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ko', 'KO'),
          const Locale('en', 'US'),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ChangeNotifierProvider(
          create: (context) => SaveMoneyViewModel(groups: [
            GroupObject(
                name: "고정지출 비용",
                type: ObjectType.group,
                group: Group(
                    willSpendMoney: 1000000,
                    spendMoney: 50000,
                    name: "chip 버튼")),
            GroupObject(
                name: "chip 버튼",
                type: ObjectType.group,
                group: Group(
                    willSpendMoney: 2000000,
                    spendMoney: 10000,
                    name: "chip 버튼")),
            GroupObject(
                name: "나를 위한 선물 나를튼",
                type: ObjectType.group,
                group: Group(
                    willSpendMoney: 3000000,
                    spendMoney: 40000,
                    name: "chip 버튼")),
            GroupObject(
                name: "버튼",
                type: ObjectType.group,
                group: Group(
                    willSpendMoney: 5000000,
                    spendMoney: 100000,
                    name: "chip 버튼")),
            GroupObject(
                name: "추가 +",
                type: ObjectType.plusButton,
                group: Group(
                    willSpendMoney: 550000,
                    spendMoney: 850000,
                    name: "chip 버튼"))
          ], spendMoney: 100000, willSpendMoney: 1000000),
          child: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  late SaveMoneyViewModel saveMoneyViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);
    final moneyFormatted = NumberFormat("#,###")
        .format(saveMoneyViewModel.selectedGroup?.spendMoney);
    final willSpendMoneyFormatted = NumberFormat("#,###")
        .format(saveMoneyViewModel.selectedGroup?.willSpendMoney);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA6BDFA),
        title: GestureDetector(
            onTap: () {
              _showDatePicker();
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
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopWillSaveMoneyWidget(
              firstText: '+ $moneyFormatted',
              secondText: '돈을 모을 예정이에요. 👍',
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TopGroupWillSpendMoneyWidget(rightText: '$willSpendMoneyFormatted'),
                  TopTotalGroupWillSpendMoneyWidget(rightText: '$willSpendMoneyFormatted'),
                ],
              ),
            ),

            SpendGroupWidget(),
            MyCalendarPage(),
            SizedBox(height: 70),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModal(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void clickButton() {
    setState(() {
      saveMoneyViewModel.selectedGroup?.spendMoney += 1000000;
      saveMoneyViewModel.updateData();
    });
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(27))),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9, // 모달 다이얼로그의 높이를 설정
          child: AddSpendingWidget()
        );
      },
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.monthYear,
            initialDateTime: this.selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        );
      },
    );
  }
}
