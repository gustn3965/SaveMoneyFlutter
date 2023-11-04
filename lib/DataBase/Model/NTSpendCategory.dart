


import 'abstract/NTObject.dart';

class NTSpendCategory implements NTObject {
  // database 필드 ------------
  int id;
  String name;
  // ----------------

  NTSpendCategory({
    required this.id,
    required this.name,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  NTSpendCategory.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? 0,
        name = map?['name'] ?? '';

  @override
  String className() {
    return 'NTSpendCategory';
  }
  static String staticClassName() {
    return 'NTSpendCategory';
  }
}
