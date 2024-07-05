import 'DBObject.dart';

class DBGroupCategory implements DBObject {
  // database 필드 ------------
  String id;
  String name;
  // --------------

  DBGroupCategory({
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

  DBGroupCategory.fromMap(Map<dynamic, dynamic>? map)
      : id = map?['id'] ?? "",
        name = map?['name'] ?? '';

  @override
  String className() {
    return 'DBGroupCategory';
  }

  static String staticClassName() {
    return 'DBGroupCategory';
  }
}
