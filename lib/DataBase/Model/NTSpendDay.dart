
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';

import '../sqlite_datastore.dart';
import 'NTMonth.dart';
import 'NTSpendCategory.dart';
import 'abstract/NTObject.dart';

class NTSpendDay implements NTObject {
  // database 필드 ------------
  int id;
  int date; // 소비날짜 (since 1970 date)
  int spend; // 소비금액
  int monthId; // 소비한 지출예상그룹의 id
  int groupId; // 소비한 지출예상그룹의 NTGroup id
  int categoryId; // 소비 카테고리 id
  // -------------------

  var db = SqliteController();

  NTSpendDay({
    required this.id,
    required this.date,
    required this.spend,
    required this.monthId,
    required this.groupId,
    required this.categoryId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'spend': spend,
      'monthId': monthId,
      'groupId': groupId,
      'categoryId': categoryId,

    };
  }

  NTSpendDay.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? 0,
        date = map?['date'] ?? 0,
        spend = map?['spend'] ?? 0,
        monthId = map?['monthId'] ?? 0,
        groupId = map?['groupId'] ?? 0,
        categoryId = map?['categoryId'] ?? 0;

  @override
  String className() {
    return 'NTSpendDay';
  }
  static String staticClassName() {
    return 'NTSpendDay';
  }


  Future<String> fetchCategoryName() async {
    List<NTSpendCategory> list = await SqliteController().fetch(NTSpendCategory.staticClassName(), where: 'id = ?', args: [categoryId]);
    return list.first.name;
  }

  Future<NTMonth?> getNtMonth() async {
    List<NTMonth> ntMonths = await db.fetch<NTMonth>(NTMonth.staticClassName(), where: 'id = ?', args: [this.monthId]);
    if (ntMonths.isEmpty) {
      return null;
    } else {
      return ntMonths.first;
    }
  }

  Future<NTSpendGroup?> getNTGroup() async {
    List<NTSpendGroup> ntGroups = await db.fetch<NTSpendGroup>(NTSpendGroup.staticClassName(), where: 'id = ?', args: [this.groupId]);
    if (ntGroups.isEmpty) {
      return null;
    } else {
      return ntGroups.first;
    }
  }

  Future<NTSpendCategory?> getNTSpendCategory() async {
    List<NTSpendCategory> ntGroups = await db.fetch<NTSpendCategory>(NTSpendCategory.staticClassName(), where: 'id = ?', args: [this.categoryId]);
    if (ntGroups.isEmpty) {
      return null;
    } else {
      return ntGroups.first;
    }
  }
}
