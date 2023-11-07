import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/view_model/add_spending_view_model.dart';
import 'package:save_money_flutter/view_model/select_date_view_model.dart';

// Widget
import 'DataBase/Model/abstract/NTObject.dart';
import 'DataBase/sqlite_datastore.dart';
import 'Widget/top_will_save_money_widget.dart';
import 'Widget/top_group_will_spend_money_widget.dart';
import 'Widget/spend_group_widget.dart';
import 'Widget/top_total_group_will_spend_money_widget.dart';
import 'Widget/AddSpending/add_spending_widget.dart';
import 'Widget/spend_list_widget.dart';

// library
import 'Widget/calendar_widget.dart';
import 'package:intl/intl.dart'; // numberFormat
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

// viewModel
import 'view_model/save_money_view_model.dart';
import 'view_model/select_date_view_model.dart';
// import 'N'

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteController().initializeAsync();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider (
              create: (context) {
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
        ],
        child: const MyApp(),
      )
  );
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
    int willSaveMoney = saveMoneyViewModel.selectedNtMonth?.currentLeftMoney ?? 0;

    final moneyFormatted = NumberFormat("#,###")
        .format(willSaveMoney);
    final willSpendMoneyFormatted = NumberFormat("#,###")
        .format(saveMoneyViewModel.selectedNtMonth?.expectedSpend ?? 0);
    final willTotalSpendMoneyFormatted = NumberFormat("#,###")
        .format(totalWillSpendMoney);

    String willSaveMoneyString = willSaveMoney < 0 ? '돈이 나갈 예정이에요.😭' : '돈을 모을 예정이에요. 👍';

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
            TopWillSaveMoneyWidget(
              firstText: '$moneyFormatted',
              secondText: willSaveMoneyString,
              color: willSaveMoney < 0 ? Colors.red : Colors.blue,
            ),
            SingleChildScrollView(

              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TopGroupWillSpendMoneyWidget(
                      rightText: '$willSpendMoneyFormatted'),
                  TopTotalGroupWillSpendMoneyWidget(
                      rightText: '$willTotalSpendMoneyFormatted'),
                ],
              ),
            ),
            SpendGroupWidget(),
            MyCalendarPage(),
            SizedBox(height: 50),
            SpendListWidget(),
            SizedBox(height: 200),
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
      // saveMoneyViewModel.selectedGroup?.spendMoney += 1000000;
      // saveMoneyViewModel.updateData();
    });
  }

  void _showModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return ChangeNotifierProvider (
            create: (context) {
              AddSpendingViewModel viewModel = AddSpendingViewModel();
              viewModel.setup(saveMoneyViewModel);
              return viewModel;
            }, child: Container(
            height:
            MediaQuery.of(context).size.height * 0.9, // 모달 다이얼로그의 높이를 설정
            child: AddSpendingWidget())
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
