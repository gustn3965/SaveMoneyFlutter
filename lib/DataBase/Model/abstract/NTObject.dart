

abstract class NTObject {
  Map<String, dynamic> toMap();

  NTObject.fromMap(Map<dynamic, dynamic>? map);

  String className();
}