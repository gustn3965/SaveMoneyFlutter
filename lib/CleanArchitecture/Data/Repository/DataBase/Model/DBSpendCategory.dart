import 'DBObject.dart';

class DBSpendCategory implements DBObject {
  // database 필드 ------------
  String id;
  String name;
  int countOfSpending;
  // ----------------

  DBSpendCategory({
    required this.id,
    required this.name,
    required this.countOfSpending,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'countOfSpending': countOfSpending,
    };
  }

  DBSpendCategory.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? "",
        name = map?['name'] ?? '',
        countOfSpending = map?['countOfSpending'] ?? 0;

  @override
  String className() {
    return 'DBSpendCategory';
  }

  static String staticClassName() {
    return 'DBSpendCategory';
  }

  @override
  int get hashCode => this.id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DBSpendCategory && id == other.id;
}
