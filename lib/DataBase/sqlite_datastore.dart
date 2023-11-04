
import 'package:path/path.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

import 'DataBaseController.dart';
import 'Model/NTSpendCategory.dart';
import 'Model/NTSpendDay.dart';
import 'Model/NTSpendGroup.dart';
import 'Model/abstract/NTObject.dart';

class SqliteTestModel implements DataBaseController {
  Database? _database;

  static SqliteTestModel? _singleton;

  factory SqliteTestModel() {
    if (_singleton == null) {
      _singleton = SqliteTestModel._internal();
    }
    return _singleton!;
  }

  SqliteTestModel._internal();

  Future<void> initializeAsync() async {
    if (_database != null) return;

    print("_database init 한번만 호출되야겠죠. ");
    _database = await initDB();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'test_database.db');

    print("db경로 ! ${path}");

    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  @override
  Future<List<T>> fetch<T extends NTObject>(String tableName, {String? where, List<Object?>? args}) async {
    // TODO: implement fetch
    List<Map> result = await _database?.query(tableName) ?? [];

    return result.map((e) {
        if (tableName == NTMonth.staticClassName()) {
            return NTMonth.fromMap(e);
        } else if (tableName == NTSpendCategory.staticClassName()) {
          return NTSpendCategory.fromMap(e);
        } else if (tableName == NTSpendDay.staticClassName()) {
          return NTSpendDay.fromMap(e);
        } else if (tableName == NTSpendGroup.staticClassName()) {
          return NTSpendGroup.fromMap(e);
        } else {
          return NTSpendGroup(id: 0, name: '');
        }
    }).toList().cast<T>();
  }

  @override
  insert(NTObject object) async {
    await _database?.insert(object.className(), object.toMap());
    print('INSERT ${object.className()} ${object.toMap()}');
  }

  @override
  delete(NTObject object) async {
    int id = object.toMap()['id'];
    await _database?.delete(object.className(), where: 'id = ?', whereArgs: [id]);
  }

  @override
  update(NTObject object) async {
    int id = object.toMap()['id'];
    await _database?.delete(object.className(), where: 'id = ?', whereArgs: [id]);
  }



  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> _onCreate(Database db, int version) async {
    List<String> querys = [queryForCreateNTMonth(),
    queryForCreateNTGroup(),
    queryForCreateNTSpend(),
    queryForCreateNTCategory()];

    for (String query in querys) {
      await db.execute(query);
    }
  }

  String queryForCreateNTMonth() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS NTMonth (
        id                          INTEGER NOT NULL,
        date                        INTEGER NOT NULL,
        groupId                     INTEGER NOT NULL,
        spendType                   INTEGER NOT NULL,
        expectedSpend               INTEGER NOT NULL,
        everyExpectedSpend          INTEGER NOT NULL,
        additionalMoney             INTEGER NOT NULL,
        PRIMARY KEY(id, date, groupId)
        )
    ''';
    return sql;
  }
  String queryForCreateNTSpend() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS NTSpendDay (
        id                           INTEGER NOT NULL,
        date                         INTEGER NOT NULL,
        spend                        INTEGER NOT NULL,
        monthId                      INTEGER NOT NULL,
        groupId                      INTEGER NOT NULL,
        categoryId                INTEGER NOT NULL,
        PRIMARY KEY(id)
        )
  ''';
    return sql;
  }

  String queryForCreateNTGroup() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS NTGroup (
        id                             INTEGER NOT NULL,
        name                           TEXT NOT NULL,
        PRIMARY KEY(id)
        )
    ''';
    return sql;
  }

  String queryForCreateNTCategory() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS NTSpendCategory (
        id                             INTEGER NOT NULL,
        name                           TEXT NOT NULL,
        PRIMARY KEY(id)
        )
    ''';
    return sql;
  }
}