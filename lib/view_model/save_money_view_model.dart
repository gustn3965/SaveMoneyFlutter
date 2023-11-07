

// import 'sqlite'

import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import '../DataBase/Model/NTMonth.dart';
import '../DataBase/Model/NTSpendCategory.dart';
import '../DataBase/Model/NTSpendDay.dart';
import '../DataBase/sqlite_datastore.dart';
import '../Extension/DateTime+Extension.dart';

class SaveMoneyViewModel extends ChangeNotifier {
  var db = SqliteController();

  List<NTMonth> ntMonths = []; // 포커싱된 내역들
  List<NTSpendGroup> ntSpendGroups = []; // ntmonth에 속하는 group들.
  NTMonth? selectedNtMonth ; // 메인
  Map<DateTime, List<NTSpendDay>>? mapSpendDayList; // 캘린더
  List<NTSpendDay>? selectedNtSpendList = [];
  NTSpendGroup? selectedGroup ;

  DateTime focusedDay = DateTime.now(); // 현재 보고 있는 날짜
  DateTime? selectedDay = DateTime.now(); // 현재 선택한 날짜

  List<NTSpendCategory> spendCategorys = [];


  void updateData() async {


    notifyListeners();
  }

  void setup() async {
    await fetchNTMonths(DateTime.now());
    this.spendCategorys = await fetchNTSpendCategory();
  }

  // 1. 캘린더 focus 이동했을때.
  // 2. 캘린더 날짜선택했을때.
  Future<void> fetchNTMonths(DateTime date) async {

    this.ntMonths = await db.fetch<NTMonth>(NTMonth.staticClassName(), where: 'date = ?', args: [indexMonthDateIdFromDateTime(date)]);

    print('fetched ntMOnths : ${ntMonths}');

    this.ntSpendGroups = await fetchNTSpendGroups();


    updateSelectedGroup(this.selectedGroup ?? this.ntSpendGroups.first);

    notifyListeners();
  }

  Future<List<NTSpendGroup>> fetchNTSpendGroups() async {
    return await db.fetch<NTSpendGroup>(NTSpendGroup.staticClassName());
  }

  Future<List<NTSpendCategory>> fetchNTSpendCategory() async {
    return await db.fetch<NTSpendCategory>(NTSpendCategory.staticClassName());
  }

  // 1. 지출그룹 선택했을떄.
  // 선택한 소비그룹에 대한 NTMonth도 찾아야함.
  Future<void> updateSelectedGroup(NTSpendGroup? selectedGroup) async {

      this.selectedGroup = selectedGroup;

      for (NTMonth month in ntMonths) {
          if (month.groupId == selectedGroup?.id) {
              print(
                  'selected group: ${selectedGroup?.name}, and find selected month: ${month}');
              this.selectedNtMonth = month;
              this.selectedNtMonth?.currentLeftMoney = await month.fetchLeftMoney;
              this.selectedNtMonth?.currentNTSpendList =
                  await month.existedSpendList();
              this.mapSpendDayList = await month.mapNtSpendList();
              notifyListeners();
              return;
          }
      }

      this.selectedNtMonth = null;
      this.selectedGroup = null;
      this.mapSpendDayList = null;

      print('selected group: ${selectedGroup?.name}, and not found selected month');
      notifyListeners();
  }

  // ntmonths 가져오고,
  // 선택된그룹가져오고,
  // 날짜항목들은 안가져옴.
  Future<void> updateFocusedDay(DateTime focusedDay) async {
    this.focusedDay = focusedDay;

    await fetchNTMonths(focusedDay);

    this.selectedNtSpendList = [];
  }

  Future<void> updateSelectedDay(DateTime selectedDay) async {

    await updateFocusedDay(focusedDay);

    this.selectedDay = selectedDay;

    List<NTSpendDay> list = await this.selectedNtMonth?.existedSpendList() ?? [];
    this.selectedNtSpendList = this.selectedNtMonth?.spendListAt(selectedDay?.day, list) ;
  }

  void addSpend(NTSpendDay spendDay) async {

    await this.db.insert(spendDay);

    await fetchNTMonths(this.selectedDay ?? DateTime.now());
    
    // await fetchNTMonths()
    notifyListeners();
  }

  Future<void> addSpendCategory(NTSpendCategory category) async {

    await this.db.insert(category);

    // await fetchNTMonths()
    notifyListeners();
  }
}