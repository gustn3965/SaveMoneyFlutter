
import 'package:path/path.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

import 'DataBaseController.dart';
import 'Model/NTSpendCategory.dart';
import 'Model/NTSpendDay.dart';
import 'Model/NTSpendGroup.dart';
import 'Model/abstract/NTObject.dart';

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
    await queryMigration();

    print('------------');
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'test_database.db');

    print("db경로 ! ${path}");

    return await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
    );
  }

  @override
  Future<List<T>> fetch<T extends NTObject>(String tableName, {String? where, List<Object?>? args, String? orderBy}) async {
    // TODO: implement fetch
    List<Map> result = await _database?.query(tableName, where: where, whereArgs: args, orderBy: orderBy) ?? [];

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
    print('🦊🦊INSERT ${object.className()} ${object.toMap()}');
  }

  @override
  delete(NTObject object) async {
    int id = object.toMap()['id'];
    await _database?.delete(object.className(), where: 'id = ?', whereArgs: [id]);
    print('🦊🦊DELETE ${object.className()} ${object.toMap()}');
  }

  @override
  update(NTObject object) async {
    int id = object.toMap()['id'];
    await _database?.update(object.className(), object.toMap(), where: 'id = ?', whereArgs: [id]);
    print('🦊🦊UPDATE ${object.className()} ${object.toMap()}');
  }

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
      await this.migration1(db);
    }

    if (oldVersion == 2) {
      // 그다음 마이그레이션
      // await this.migration1(db);
    }
  }

  Future<void> migration1(Database db) async {
    // NTSpendCategory 테이블에 countOfSpending 컬럼 추가 쿼리 실행
    await db.execute('ALTER TABLE NTSpendCategory ADD COLUMN countOfSpending INTEGER NOT NULL DEFAULT 0');
  }

  Future<void> queryMigration() async {
    if (this._oldVersion == 1) {
      print("🔥 MIGRATION QUERY 1 .........");
      await migration1Query();
    }

    if (this._oldVersion == 2) {
      // migration2Query();
    }
  }

  Future<void> migration1Query() async {
    List<NTSpendCategory> categoryList = await fetch<NTSpendCategory>(NTSpendCategory.staticClassName());
    List<NTSpendDay> spendList = await fetch(NTSpendDay.staticClassName());
    for (NTSpendDay spendDay in spendList) {
      for (NTSpendCategory category in categoryList) {
        if (category.id == spendDay.categoryId) {
          category.countOfSpending += 1;
        }
      }
    }

    for (NTSpendCategory category in categoryList) {
      await update(category);
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
        countOfSpending                INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(id)
        )
    ''';
    return sql;
  }
}