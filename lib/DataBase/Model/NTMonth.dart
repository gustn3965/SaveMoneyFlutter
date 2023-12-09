import 'package:save_money_flutter/DataBase/Model/NTSpendCategory.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';

import '../../Extension/DateTime+Extension.dart';
import '../sqlite_datastore.dart';
import 'NTSpendDay.dart';
import 'abstract/NTObject.dart';
import 'abstract/model_header.dart';

class NTMonth implements NTObject {
  // database 필드 ------------
  int id;
  int date; // 소비 달 (month) since 1970 date
  int groupId; // 지출예상그룹의 이름 id
  int spendType; // 소비타입
  int expectedSpend; // 이번달 총 지출 예정 금액
  int everyExpectedSpend; // 매일 소비 지출 예정 금액
  int additionalMoney;
  //-------------

  NTMonth({
    required this.id,
    required this.date,
    required this.groupId,
    required this.spendType,
    required this.expectedSpend,
    required this.everyExpectedSpend,
    required this.additionalMoney,
  });

  int? currentLeftMoney = 0;
  List<NTSpendDay>? currentNTSpendList;

  String dateStringYYMM() {
    return '${yearFromSince1970(this.date)}년 ${monthFromSince1970(this.date)}월';
  }

  List<NTSpendDay> spendListAt(int? day, List<NTSpendDay> inList) {
    if (day == null) {
      return [];
    }

    List<NTSpendDay> spendList = [];

    for (NTSpendDay spend in inList) {
      if (dayFromSince1970(spend.date) == day) {
        spendList.add(spend);
      }
    }
    return spendList;
  }

  // Future Fetch
  Future<int> get fetchLeftMoney async {
    List<NTSpendDay> spendList = await existedSpendList();

    int sum = 0;

    int daysInMonth = daysInMonthFromSince1970(this.date);

    int totalMoney = 0;
    for (int day = 1; day <= daysInMonth; day++) {
      List<NTSpendDay> spends = spendListAt(day, spendList);
      if (spends.isNotEmpty) {
        totalMoney += this.everyExpectedSpend;
        for (NTSpendDay spend in spends) {
          totalMoney -= spend.spend;
        }
      }
    }

    print('지금 현재 금액... ${totalMoney}원');
    return totalMoney;
  }

  Future<List<NTSpendDay>> existedSpendList() async {
    return await SqliteController().fetch(NTSpendDay.staticClassName(),
        where: 'monthId = ? ORDER BY date', args: [id]);
  }

  Future<Map<DateTime, List<NTSpendDay>>> mapNtSpendList() async {
    List<NTSpendDay> spendList = await existedSpendList();

    int daysInMonth = daysInMonthFromSince1970(this.date);

    Map<DateTime, List<NTSpendDay>> mapList = {};

    for (int day = 1; day <= daysInMonth; day++) {
      List<NTSpendDay> spends = spendListAt(day, spendList);

      if (spends.isNotEmpty) {
        DateTime dateTime = DateTime.utc(
            yearFromSince1970(this.date), monthFromSince1970(this.date), day);
        mapList[dateTime] = spends;
      }
    }

    return mapList;
  }

  Future<Map<DateTime, List<NTSpendDay>>>
      currentNTSpendListMapNtSpendList() async {
    List<NTSpendDay> spendList = this.currentNTSpendList ?? [];

    int daysInMonth = daysInMonthFromSince1970(this.date);

    Map<DateTime, List<NTSpendDay>> mapList = {};

    for (int day = 1; day <= daysInMonth; day++) {
      List<NTSpendDay> spends = spendListAt(day, spendList);

      if (spends.isNotEmpty) {
        DateTime dateTime = DateTime.utc(
            yearFromSince1970(this.date), monthFromSince1970(this.date), day);
        mapList[dateTime] = spends;
      }
    }

    return mapList;
  }

  Future<NTSpendGroup> spendGroup() async {
    List<NTSpendGroup> groups = await SqliteController().fetch(
        NTSpendGroup.staticClassName(),
        where: 'id = ?',
        args: [groupId]);
    return groups.first;
  }

  Future<List<NTSpendCategory>> fetchExistSpendCategorys() async {
    Set<int> categoryId = {};
    Set<NTSpendCategory> list = {};
    for (NTSpendDay spendDay in this.currentNTSpendList ?? []) {
      categoryId.add(spendDay.categoryId);
    }

    if (categoryId.isEmpty) {
      return [];
    }

    String whereQuery = '';
    for (int uniqueCategoryId in categoryId) {
      if (whereQuery.isEmpty) {
        whereQuery += '(id = ?';
      } else {
        whereQuery += ' OR id = ?';
      }
    }
    whereQuery += ')';
    List<NTSpendCategory> spendCategoryList = await SqliteController().fetch(
        NTSpendCategory.staticClassName(),
        where: whereQuery,
        args: categoryId.toList(),
        orderBy: 'countOfSpending DESC');
    return spendCategoryList;
  }

  Future<List<NTSpendDay>> fetchNTSpendListByCategoryId(int categoryId) async {
    List<NTSpendDay> spendList = await SqliteController().fetch(
        NTSpendDay.staticClassName(),
        where: 'monthId = ? AND categoryId = ?',
        args: [this.id, categoryId]);
    return spendList;
  }

  Future<String> fetchGroupName() async {
    List<NTSpendGroup> group = await SqliteController().fetch(
        NTSpendGroup.staticClassName(),
        where: 'id = ?',
        args: [this.groupId]);

    return group.first.name;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'groupId': groupId,
      'spendType': spendType,
      'expectedSpend': expectedSpend,
      'everyExpectedSpend': everyExpectedSpend,
      'additionalMoney': additionalMoney,
    };
  }

  // NTMonth.fromMap
  NTMonth.fromMap(Map<dynamic, dynamic>? map)
      // return NTMonth(id: 0, date: 0, groupId: 0, spendType: 0, expectedSpend: 0, everyExpectedSpend: 0, additionalMoney: 0);
      : id = map?['id'] ?? 0,
        date = map?['date'] ?? 0,
        groupId = map?['groupId'] ?? 0,
        spendType = map?['spendType'] ?? 0,
        expectedSpend = map?['expectedSpend'] ?? 0,
        everyExpectedSpend = map?['everyExpectedSpend'] ?? 0,
        additionalMoney = map?['additionalMoney'] ?? 0;

  @override
  String className() {
    return 'NTMonth';
  }

  static String staticClassName() {
    return 'NTMonth';
  }
}
