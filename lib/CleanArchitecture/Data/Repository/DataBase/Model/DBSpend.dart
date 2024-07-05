import 'DBObject.dart';

enum DBSpendType {
  noSpend(rawValue: 0),
  spend(rawValue: 1);

  const DBSpendType({required this.rawValue});
  final int rawValue;

  factory DBSpendType.fromRawValue(int rawValue) {
    return values.firstWhere((e) => e.rawValue == rawValue);
  }
}

class DBSpend implements DBObject {
  // int id, int date, int spend, int monthId, int groupId, int categoryId

  // database 필드 ------------
  String id;
  int date; // 소비날짜 (since 1970 date)
  int spend; // 소비금액
  String groupMonthId; // 소비한 지출예상그룹의 id
  String groupCategoryId; // 소비한 지출예상그룹의 NTGroup id
  String spendCategoryId; // 소비 카테고리 id
  DBSpendType
      spendType; // 소비타입(0 = 무지출, 1 = 소비)  SpendType.noSpend, SpendType.spend
  String description;
  // -------------------

  DBSpend({
    required this.id,
    required this.date,
    required this.spend,
    required this.groupMonthId,
    required this.groupCategoryId,
    required this.spendCategoryId,
    required this.spendType,
    required this.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'spend': spend,
      'groupMonthId': groupMonthId,
      'groupCategoryId': groupCategoryId,
      'spendCategoryId': spendCategoryId,
      'spendType': spendType.rawValue,
      'description': description,
    };
  }

  DBSpend.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? "",
        date = map?['date'] ?? 0,
        spend = map?['spend'] ?? 0,
        groupMonthId = map?['groupMonthId'] ?? "",
        groupCategoryId = map?['groupCategoryId'] ?? "",
        spendCategoryId = map?['spendCategoryId'] ?? "",
        spendType = DBSpendType.fromRawValue(map?['spendType'] ?? 0),
        description = map?['description'] ?? "";

  @override
  String className() {
    return 'DBSpend';
  }

  static String staticClassName() {
    return 'DBSpend';
  }
}
