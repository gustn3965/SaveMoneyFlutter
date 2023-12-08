

// import 'sqlite'

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import '../DataBase/Model/NTMonth.dart';
import '../DataBase/Model/NTSpendCategory.dart';
import '../DataBase/Model/NTSpendDay.dart';
import '../DataBase/sqlite_datastore.dart';
import '../Extension/Color+Extension.dart';
import '../Extension/DateTime+Extension.dart';
import 'Model/MonthSpendModel.dart';
import 'Model/YearSpendModel.dart';




class SaveMoneyViewModel extends ChangeNotifier {
  var db = SqliteController();

  List<NTMonth> ntMonths = []; // 포커싱된 내역들
  List<NTSpendGroup> ntSpendGroups = []; // ntmonth에 속하는 group들.
  List<NTMonth> selectedNtMonths = []; // 메인
  Map<DateTime, List<NTSpendDay>>? mapSpendDayList; // 캘린더
  List<NTSpendDay>? selectedNtSpendList = [];
  List<NTSpendGroup> selectedGroups = [];

  DateTime focusedDay = DateTime.now(); // 현재 보고 있는 날짜
  DateTime? selectedDay = DateTime.now(); // 현재 선택한 날짜

  List<NTSpendCategory> allSpendCategorys = [];
  List<NTSpendCategory> ntMonthSpendCategorys = [];

  List<MonthSpendModel> monthSpendModels = [];
  List<YearNtMonthSpendModel> yearSpendModels = [];  // [0] = List<음식>, [1] = List<커피>

  void updateData() async {


    notifyListeners();
  }

  void setup() async {
    await fetchNTMonths(DateTime.now());
    this.allSpendCategorys = await fetchNTSpendCategory();
  }

  // 1. 캘린더 focus 이동했을때.
  // 2. 캘린더 날짜선택했을때.
  Future<void> fetchNTMonths(DateTime date) async {

    this.ntMonths = await db.fetch<NTMonth>(NTMonth.staticClassName(), where: 'date = ?', args: [indexMonthDateIdFromDateTime(date)]);

    print('fetched ntMOnths : ${ntMonths}');

    this.ntSpendGroups = await fetchNTSpendGroups();


    await updateSelectedGroups(this.selectedGroups);

    notifyListeners();
  }

  Future<List<NTSpendGroup>> fetchNTSpendGroups() async {
    return await db.fetch<NTSpendGroup>(NTSpendGroup.staticClassName());
  }

  Future<List<NTSpendCategory>> fetchNTSpendCategory() async {
    return await db.fetch<NTSpendCategory>(NTSpendCategory.staticClassName(), orderBy: "countOfSpending DESC");
  }

  // 1. 지출그룹 선택했을떄.
  // 선택한 소비그룹에 대한 NTMonth도 찾아야함.
  Future<bool> updateSelectedGroups(List<NTSpendGroup> selectedGroups) async {

     this.selectedGroups = [];
      this.mapSpendDayList = {};

      List<NTMonth> tempSelectedGroups = [];
      for (NTMonth month in ntMonths) {
          for (NTSpendGroup spendGroup in selectedGroups) {
              if (month.groupId == spendGroup.id) {

                  this.selectedGroups.add(spendGroup);

                  month.currentLeftMoney = await month.fetchLeftMoney; // TODO: 코드 수정하기 (futureBuilder로 쓰거나 )
                  month.currentNTSpendList = await month.existedSpendList(); // TODO: 코드 수정하기 (futureBuilder로 쓰거나 )

                  Map<DateTime, List<NTSpendDay>> tempMapNtSpendList = await month.mapNtSpendList();
                  for (DateTime key in tempMapNtSpendList.keys) {
                      List<NTSpendDay> values = tempMapNtSpendList[key] ?? [];
                      if (this.mapSpendDayList?[key] == null) {
                          this.mapSpendDayList?[key] = values;
                      } else {
                          this.mapSpendDayList?[key]?.addAll(values);
                      }
                  }
                  // this.mapSpendDayList
                  tempSelectedGroups.add(month);
              }
          }
      }

      this.selectedNtMonths = tempSelectedGroups;

      await updateMonthSpendModels();

      this.yearSpendModels = [];

      notifyListeners();
      if (tempSelectedGroups.isEmpty) {

          print('selected group: ${selectedGroups}, and not found selected month 👀');
          return false;
      } else {
         print('selected groups: ${selectedGroups}, and 👍 find selected months: ${tempSelectedGroups}');
         return true;
      }
  }

  Future<bool> updateSpendCategoryGroups(List<NTSpendCategory> selectedCategory) async {

    this.mapSpendDayList = {};

    for (NTMonth month in this.selectedNtMonths) {
      List<NTSpendDay> spendList = await month.existedSpendList();

      List<NTSpendDay> filteredSpendList = spendList.where((spendDay) {
        return selectedCategory.any((category) => category.id == spendDay.categoryId);
      }).toList();

      month.currentNTSpendList = filteredSpendList;

      Map<DateTime, List<NTSpendDay>> tempMapNtSpendList = await month.currentNTSpendListMapNtSpendList();
      for (DateTime key in tempMapNtSpendList.keys) {
        List<NTSpendDay> values = tempMapNtSpendList[key] ?? [];
        if (this.mapSpendDayList?[key] == null) {
          this.mapSpendDayList?[key] = values;
        } else {
          this.mapSpendDayList?[key]?.addAll(values);
        }
      }
    }

    // 선택된 Ntmonth의 모든 카테고리내역들
    if (selectedCategory.length == 1) {
      await updateYearSpendModelsByCategoryId(selectedCategory.first.id);
    } else {
      this.yearSpendModels = [];
    }

    notifyListeners();

    return true;
  }
  // ntmonths 가져오고,
  // 선택된그룹가져오고,
  // 날짜항목들은 안가져옴.
  Future<void> updateFocusedDay(DateTime focusedDay) async {

    if (isEqualDateMonth(focusedDay, this.focusedDay)) {
      return;
    }
    this.focusedDay = focusedDay;

    await fetchNTMonths(focusedDay);

    this.selectedNtSpendList = [];
  }

  Future<void> updateSelectedDay(DateTime selectedDay) async {
    await updateFocusedDay(selectedDay);

    this.selectedDay = selectedDay;

    List<NTSpendDay> tempList = [];
    for (NTMonth month in this.selectedNtMonths) {
        List<NTSpendDay> list = await month.existedSpendList();
        tempList.addAll(month.spendListAt(selectedDay?.day, list));
    }
    this.selectedNtSpendList = tempList;

    notifyListeners();
  }

  Future<void> addSpend(NTSpendDay spendDay) async {

    await this.db.insert(spendDay);

    await fetchNTMonths(this.selectedDay ?? DateTime.now());

    await updateSelectedDay(this.selectedDay ?? DateTime.now());
    // await fetchNTMonths()
    notifyListeners();
  }

  Future<void> updateSpend(NTSpendDay spendDay) async {
    await this.db.update(spendDay);

    await fetchNTMonths(this.selectedDay ?? DateTime.now());
    await updateSelectedDay(this.selectedDay ?? DateTime.now());
    // await fetchNTMonths()
    notifyListeners();
  }

  Future<void> deleteSpend(NTSpendDay spendDay) async {
    await this.db.delete(spendDay);

    await fetchNTMonths(this.selectedDay ?? DateTime.now());
    await updateSelectedDay(this.selectedDay ?? DateTime.now());
    // await fetchNTMonths()
    notifyListeners();
  }

  Future<void> addSpendCategory(NTSpendCategory category) async {

    await this.db.insert(category);

    // await fetchNTMonths()
    notifyListeners();
  }

  Future<void> addSpendGroup(NTSpendGroup spendGroup) async {

    List<NTSpendGroup> findSpendGroups = await this.db.fetch(NTSpendGroup.staticClassName(), where: "id = ?", args: [spendGroup.id]);
    if (findSpendGroups.isEmpty) {
        await this.db.insert(spendGroup);
    }

    await this.fetchNTMonths(this.focusedDay);

    notifyListeners();
  }

  Future<void> addNtMonth(NTMonth ntMonth) async {
    await this.db.insert(ntMonth);
    await this.fetchNTMonths(this.focusedDay);

    notifyListeners();
  }
  Future<void> updateNtMonth(NTMonth ntMonth) async {
    await this.db.update(ntMonth);
    await this.fetchNTMonths(this.focusedDay);

    notifyListeners();
  }

  Future<void> deleteNtMonthsBy(NTSpendGroup spendGroup) async {
      List<NTMonth> months = await spendGroup.ntMonths();
      for (NTMonth month in months) {
        // 소비내역도 모두 삭제해야함.
        await this.db.delete(month);
      }
      notifyListeners();
  }

  Future<void> deleteNTSpendGroup(NTSpendGroup spendGroup) async {
    await this.db.delete(spendGroup);

    await fetchNTMonths(this.focusedDay);

    notifyListeners();
  }

  Future<void> updateMonthSpendModels() async {
    Map<int, MonthSpendModel> spendList = {};
    for (NTMonth month in this.selectedNtMonths) {
      for (NTSpendDay spendDay in month.currentNTSpendList ?? []) {
        if (spendList[spendDay.categoryId] == null) {
          String categoryName = await spendDay.fetchCategoryName();
          spendList[spendDay.categoryId] = MonthSpendModel(spendDay: spendDay, price: spendDay.spend, count: 1, categoryName: categoryName);
        } else {
          spendList[spendDay.categoryId]?.price += spendDay.spend;
          spendList[spendDay.categoryId]?.count += 1;
        }
      }
    }
    List<MonthSpendModel> sortedList = spendList.values.toList()
      ..sort((a, b) => b.price.compareTo(a.price));

    this.monthSpendModels = sortedList;

  }

  Future<void> updateYearSpendModelsByCategoryId(int categoryId) async {
    List<YearNtMonthSpendModel> newList = [];

    for (NTMonth month in this.selectedNtMonths) {

      // NTMonth의 모든 월별내역들
        List<NTMonth> yearMonths = await this.db.fetch(NTMonth.staticClassName(), where: 'groupId = ?', args: [month.groupId]);

        List<YearMonthCategorySpendModel> spendModels = [];
        for (NTMonth yearMonth in yearMonths) {
            List<NTSpendDay> spendList = await yearMonth.fetchNTSpendListByCategoryId(categoryId);


            int price = 0;
            int date = yearMonth.date;
            Color color = Colors.blueAccent;
            String categoryName = '';
            for (NTSpendDay spendDay in spendList) {
                price += spendDay.spend;
                color = uniqueColorFromIndex(spendDay.categoryId);
                categoryName = await spendDay.fetchCategoryName();
            }

            spendModels.add(YearMonthCategorySpendModel(price: price, date: date, color: color, categoryName: categoryName));
        }

        String monthGroupName = await month.fetchGroupName();
        newList.add(YearNtMonthSpendModel(monthGroupName: monthGroupName, spendModels: spendModels));
    }

    this.yearSpendModels = newList;
  }
}


