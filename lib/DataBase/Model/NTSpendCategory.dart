


import 'abstract/NTObject.dart';

class NTSpendCategory implements NTObject {
  // database 필드 ------------
  int id;
  String name;
  int countOfSpending;
  // ----------------

  NTSpendCategory({
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

  NTSpendCategory.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? 0,
        name = map?['name'] ?? '',
        countOfSpending = map?['countOfSpending'] ?? 0;

  @override
  String className() {
    return 'NTSpendCategory';
  }
  static String staticClassName() {
    return 'NTSpendCategory';
  }


  @override
  int get hashCode => this.id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NTSpendCategory && id == other.id;
}
