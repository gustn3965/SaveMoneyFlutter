import 'Model/abstract/NTObject.dart';

abstract class DataBaseController {
  Future<void> initializeAsync();

  Future<List<T>> fetch<T extends NTObject>(String tableName,
      {String? where, List<Object?>? args});

  insert(NTObject object);

  delete(NTObject object);

  update(NTObject object);

  deleteAll(String tableName);
}
