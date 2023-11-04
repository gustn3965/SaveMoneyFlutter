
import 'abstract/NTObject.dart';

class NTSpendGroup implements NTObject {
  // database 필드 ------------
  int id;
  String name;
  // --------------

  NTSpendGroup({
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
  NTSpendGroup.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? 0,
        name = map?['name'] ?? '';

  @override
  String className() {
    return 'NTGroup';
  }
  static String staticClassName() {
    return 'NTGroup';
  }
}

