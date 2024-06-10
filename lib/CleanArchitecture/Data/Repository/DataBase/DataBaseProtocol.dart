import 'Model/DBObject.dart';

abstract class DataBaseProtocol {
  Future<void> initializeAsync();

  Future<List<T>> fetch<T extends DBObject>(String tableName,
      {String? where, List<Object?>? args});

  Future<List<Map<String, Object?>>> fetchRawQuery(String sql,
      [List<Object?>? arguments]);

  insert(DBObject object);

  delete(DBObject object);

  update(DBObject object);

  deleteAll(String tableName);
}
