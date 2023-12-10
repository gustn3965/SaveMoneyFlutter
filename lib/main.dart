import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';
import 'package:save_money_flutter/Widget/Main/Chart/Total/total_spend_category_widget.dart';
import 'package:save_money_flutter/view_model/add_spending_view_model.dart';
import 'package:save_money_flutter/view_model/select_date_view_model.dart';

// Widget
import 'DataBase/Model/abstract/NTObject.dart';
import 'DataBase/sqlite_datastore.dart';
import 'Widget/Main/Chart/month/month_spend_list_barChart.dart';
import 'Widget/Main/Chart/month/month_spend_list_graphChart.dart';
import 'Widget/Main/month_spend_list_widget.dart';
import 'Widget/Main/spend_category_widget.dart';
import 'Widget/Main/top_will_save_money_widget.dart';
import 'Widget/Main/top_group_will_spend_money_widget.dart';
import 'Widget/Main/spend_group_widget.dart';
import 'Widget/Main/top_total_group_will_spend_money_widget.dart';
import 'Widget/AddSpending/add_spending_widget.dart';
import 'Widget/Main/spend_list_widget.dart';

// library
import 'Widget/Main/calendar_widget.dart';
import 'package:intl/intl.dart'; // numberFormat
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

// viewModel
import 'Widget/Main/Chart/Total/total_spend_list_barChart.dart';
import 'view_model/save_money_view_model.dart';
import 'view_model/select_date_view_model.dart';
// import 'N'

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteController().initializeAsync();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) {
        SaveMoneyViewModel viewModel = SaveMoneyViewModel();
        viewModel.setup();
        return viewModel;
      }),
      // ChangeNotifierProvider (
      //     create: (context) {
      //       AddSpendingViewModel viewModel = AddSpendingViewModel();
      //       viewModel.setup();
      //       return viewModel;
      //     })
      //     })
    ],
    child: const MyApp(),
  ));
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
  late SaveMoneyViewModel saveMoneyViewModel;
  late SaveMoneyViewModel selectDateViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);
    selectDateViewModel = Provider.of<SaveMoneyViewModel>(context);

    int totalWillSpendMoney = 0;
    for (NTMonth month in saveMoneyViewModel.ntMonths) {
      totalWillSpendMoney += month.expectedSpend;
    }
    int willSaveMoney = saveMoneyViewModel.selectedNtMonths.isEmpty
        ? 0
        : saveMoneyViewModel.selectedNtMonths
            .map((e) => e.currentLeftMoney ?? 0)
            .reduce((int value, element) => value + element);

    final moneyFormatted = NumberFormat("#,###").format(willSaveMoney);
    final willSpendMoneyFormatted = NumberFormat("#,###").format(
        saveMoneyViewModel.selectedNtMonths.isEmpty
            ? 0
            : saveMoneyViewModel.selectedNtMonths
                .map((e) => e.expectedSpend)
                .reduce((int value, element) => value + element));
    final willTotalSpendMoneyFormatted =
        NumberFormat("#,###").format(totalWillSpendMoney);
    final willEverySpendMoney = NumberFormat("매일 (#,###)").format(
        saveMoneyViewModel.selectedNtMonths.isEmpty
            ? 0
            : saveMoneyViewModel.selectedNtMonths
                .map((e) => e.everyExpectedSpend)
                .reduce((int value, element) => value + element));

    String selectedGroupName = saveMoneyViewModel.selectedGroups.isEmpty
        ? ''
        : saveMoneyViewModel.selectedGroups
            .map((e) => e.name)
            .reduce((String value, element) => value + ', ${element}');
    String willSaveMoneyString =
        willSaveMoney < 0 ? '돈이 나갈 예정이에요.😭' : '돈을 모을 예정이에요. 👍';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA6BDFA),
          title: GestureDetector(
              onTap: () {
                _showDatePicker();
              },
              child: Text(
                DateFormat('yyyy-MM').format(selectDateViewModel.focusedDay),
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
              if (saveMoneyViewModel.selectedGroups.isEmpty)
                Container(
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
                )
              else
                TopWillSaveMoneyWidget(
                  groupNameText: selectedGroupName,
                  groupWillSaveMoneyText: '$moneyFormatted',
                  descriptionText: willSaveMoneyString,
                  willSpendMoneyText: willSpendMoneyFormatted,
                  willEverySpendMoneyText: willEverySpendMoney,
                  moneyColor: willSaveMoney < 0 ? Colors.red : Colors.blue,
                ),
              SpendGroupWidget(),
              SpendCategoryWidget(),
              MyCalendarPage(),
              SizedBox(height: 50),
              SpendListWidget(), // 일간 내역
              MonthSpendListGraphChart(), // 월간 내역 그래프
              TotalSpendListBarChart(), // 모든 기간 내역 (바차트)
              TotalSpendCategoryWidget(), // 모든 기간에 소비된 카테고리
              // MonthSpendListWidget(), // 월간 내역 리스트로.
              SizedBox(height: 200),
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  saveMoneyViewModel.updateFocusedDay(
                      dateTimeBeforeMonth(saveMoneyViewModel.focusedDay));
                },
                tooltip: 'Increment',
                child: const Icon(Icons.arrow_back),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () {
                  saveMoneyViewModel.updateFocusedDay(
                      dateTimeAfterMonth(saveMoneyViewModel.focusedDay));
                },
                tooltip: 'Increment',
                child: const Icon(Icons.arrow_forward),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () {
                  _showAddSpendCategory(context);
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ])
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void _showAddSpendCategory(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
            create: (context) {
              AddSpendingViewModel viewModel = AddSpendingViewModel();
              viewModel.setup(saveMoneyViewModel);
              return viewModel;
            },
            child: Container(
                height: MediaQuery.of(context).size.height *
                    0.9, // 모달 다이얼로그의 높이를 설정
                child: AddSpendingWidget()));
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
            initialDateTime: selectDateViewModel.focusedDay,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectDateViewModel.focusedDay = newDate;
                selectDateViewModel.updateData();
              });
            },
          ),
        );
      },
    );
  }
}
