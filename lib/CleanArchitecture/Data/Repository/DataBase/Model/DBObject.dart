abstract class DBObject {
  Map<String, dynamic> toMap();

  DBObject.fromMap(Map<dynamic, dynamic>? map);

  String className();
}
