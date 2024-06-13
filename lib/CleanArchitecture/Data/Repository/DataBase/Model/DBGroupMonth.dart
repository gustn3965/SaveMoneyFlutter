import 'DBObject.dart';

class DBGroupMonth implements DBObject {
  // database 필드 ------------
  String id;
  int date; // 소비 달 (month) since 1970 date
  String groupCategoryId; // 지출예상그룹의 이름 id
  int plannedBudget; // 이번달 총 지출 예정 금액

  //-------------

  DBGroupMonth({
    required this.id,
    required this.date,
    required this.groupCategoryId,
    required this.plannedBudget,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'groupCategoryId': groupCategoryId,
      'plannedBudget': plannedBudget,
    };
  }

  // NTMonth.fromMap
  DBGroupMonth.fromMap(Map<dynamic, dynamic>? map)
      // return NTMonth(id: 0, date: 0, groupId: 0, expectedSpend: 0
      : id = map?['id'] ?? "",
        date = map?['date'] ?? 0,
        groupCategoryId = map?['groupCategoryId'] ?? "",
        plannedBudget = map?['plannedBudget'] ?? 0;

  @override
  String className() {
    return 'DBGroupMonth';
  }

  static String staticClassName() {
    return 'DBGroupMonth';
  }
}
