
import '../sqlite_datastore.dart';
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


  Future<String> fetchString() async {
    print("async fetchString........}");
    List<NTSpendCategory> list = await SqliteController().fetch(NTSpendCategory.staticClassName(), where: 'id = ?', args: [categoryId]);
    print("async fetchString........${list.first.name}");
    return list.first.name;
  }
}
