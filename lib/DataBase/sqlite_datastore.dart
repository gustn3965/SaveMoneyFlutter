import 'package:path/path.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:save_money_flutter/DataBase/sqlite_datastore_NTSpendDay_extension.dart';
import 'package:save_money_flutter/DataBase/sqlite_datastore_migration_extension.dart';
import 'package:save_money_flutter/DataBase/sqlite_datastore_table_extension.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

import 'DataBaseController.dart';
import 'Model/NTSpendCategory.dart';
import 'Model/NTSpendDay.dart';
import 'Model/NTSpendGroup.dart';
import 'Model/abstract/NTObject.dart';

const int DB_SCHEME_VERSION = 3;

class SqliteController implements DataBaseController {
  Database? _database;

  int _oldVersion = 0;
  static SqliteController? _singleton;

  factory SqliteController() {
    if (_singleton == null) {
      _singleton = SqliteController._internal();
    }
    return _singleton!;
  }

  SqliteController._internal();

  Future<void> initializeAsync() async {
    if (_database != null) return;

    print("_database init 한번만 호출되야겠죠. ");
    _database = await initDB();
    await queryMigration(_oldVersion);

    print('------------');
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'test_database.db');

    print("db경로 ! ${path}");

    return await openDatabase(
      path,
      version: DB_SCHEME_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  @override
  Future<List<T>> fetch<T extends NTObject>(String tableName,
      {String? where, List<Object?>? args, String? orderBy}) async {
    // TODO: implement fetch
    List<Map> result = await _database?.query(tableName,
            where: where, whereArgs: args, orderBy: orderBy) ??
        [];

    return result
        .map((e) {
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
        })
        .toList()
        .cast<T>();
  }

  @override
  insert(NTObject object) async {
    await _database?.insert(object.className(), object.toMap());

    print('🦊🦊INSERT ${object.className()} ${object.toMap()}');

    // 소비 추가할때, 보정
    if (object is NTSpendDay) {
      // noSpend_test.dart
      await deleteNoSpendIfNoSpend(object);
      await deleteNoSpendIfSpend(object);
      await deleteDuplicatedNoSpend(object);
    }
  }

  @override
  delete(NTObject object) async {
    int id = object.toMap()['id'];
    await _database
        ?.delete(object.className(), where: 'id = ?', whereArgs: [id]);
    print('🦊🦊DELETE ${object.className()} ${object.toMap()}');
  }

  @override
  update(NTObject object) async {
    int id = object.toMap()['id'];
    await _database?.update(object.className(), object.toMap(),
        where: 'id = ?', whereArgs: [id]);
    print('🦊🦊UPDATE ${object.className()} ${object.toMap()}');
  }

  @override
  deleteAll(String tableName) async {
    int? count = await _database?.delete(tableName, where: null);

    print('🦊🦊DELETE ALL  ${tableName}, ${count} deleted');
  }

  // TABLE
  Future<void> _onCreate(Database db, int version) async {
    print("👩👩 DB NEW CREATE! : ${version}");

    List<String> querys = [
      queryForCreateNTMonth(),
      queryForCreateNTGroup(),
      queryForCreateNTSpend(),
      queryForCreateNTCategory()
    ];

    for (String query in querys) {
      await db.execute(query);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    this._oldVersion = oldVersion;
    print("👩🏻‍🦳👩🏻‍DB SCHEME old version : ${_oldVersion}");
    print("👩🏻‍🦳👩🏻‍DB SCHEME NEW version : ${newVersion}");

    if (oldVersion == 1) {
      print("🔥 MIGRATION DB TABLE 1 .........");
      await this.migration1(db);
      await this.migration2(db);
    } else if (oldVersion == 2) {
      print("🔥 MIGRATION DB TABLE 2 .........");
      await this.migration2(db);
    }
  }
}
