


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


