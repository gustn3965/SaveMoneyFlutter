import 'DBObject.dart';

class DBGroupMonth implements DBObject {
  // database 필드 ------------
  String id;
  int date; // 소비 달 (month) since 1970 date
  String groupCategoryId; // 지출예상그룹의 이름 id
  int expectedSpend; // 이번달 총 지출 예정 금액
  int everyExpectedSpend; // 매일 소비 지출 예정 금액
  int additionalMoney;

  //-------------

  DBGroupMonth({
    required this.id,
    required this.date,
    required this.groupCategoryId,
    required this.expectedSpend,
    required this.everyExpectedSpend,
    required this.additionalMoney,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'groupCategoryId': groupCategoryId,
      'expectedSpend': expectedSpend,
      'everyExpectedSpend': everyExpectedSpend,
      'additionalMoney': additionalMoney,
    };
  }

  // NTMonth.fromMap
  DBGroupMonth.fromMap(Map<dynamic, dynamic>? map)
      // return NTMonth(id: 0, date: 0, groupId: 0, expectedSpend: 0, everyExpectedSpend: 0, additionalMoney: 0);
      : id = map?['id'] ?? "",
        date = map?['date'] ?? 0,
        groupCategoryId = map?['groupCategoryId'] ?? "",
        expectedSpend = map?['expectedSpend'] ?? 0,
        everyExpectedSpend = map?['everyExpectedSpend'] ?? 0,
        additionalMoney = map?['additionalMoney'] ?? 0;

  @override
  String className() {
    return 'DBGroupMonth';
  }

  static String staticClassName() {
    return 'DBGroupMonth';
  }
}
