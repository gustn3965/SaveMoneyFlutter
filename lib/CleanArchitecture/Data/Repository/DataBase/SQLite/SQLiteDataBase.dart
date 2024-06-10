import 'package:path/path.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/DataBaseProtocol.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBGroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBGroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBSpend.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/SQLite/SQLiteDataBase_migration.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/SQLite/SQLiteDataBase_spend.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/SQLite/SQLiteDataBase_table.dart';
import 'package:save_money_flutter/DataBase/sqlite_datastore.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../Model/DBObject.dart';
import '../Model/DBSpendCategory.dart';

const int DB_SCHEME_VERSION = 1;

class SQLiteDataBase implements DataBaseProtocol {
  SqliteController beforeSql = SqliteController();
  Database? _database;

  int _oldVersion = 0;
  static SQLiteDataBase? _singleton;

  factory SQLiteDataBase() {
    if (_singleton == null) {
      _singleton = SQLiteDataBase._internal();
    }
    return _singleton!;
  }

  SQLiteDataBase._internal();

  Future<void> initializeAsync() async {
    await beforeSql.initializeAsync();

    if (_database != null) return;

    print("_database init 한번만 호출되야겠죠. ");
    _database = await initDB();
    await queryMigration(_oldVersion);

    print('------------');
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'sql_database.db');

    print("db경로 ! ${path}");

    return await openDatabase(
      path,
      version: DB_SCHEME_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  @override
  Future<List<T>> fetch<T extends DBObject>(String tableName,
      {String? where, List<Object?>? args, String? orderBy}) async {
    // TODO: implement fetch
    List<Map> result = await _database?.query(tableName,
            where: where, whereArgs: args, orderBy: orderBy) ??
        [];

    return result
        .map((e) {
          if (tableName == DBGroupMonth.staticClassName()) {
            return DBGroupMonth.fromMap(e);
          } else if (tableName == DBSpendCategory.staticClassName()) {
            return DBSpendCategory.fromMap(e);
          } else if (tableName == DBSpend.staticClassName()) {
            return DBSpend.fromMap(e);
          } else if (tableName == DBGroupCategory.staticClassName()) {
            return DBGroupCategory.fromMap(e);
          } else {
            return DBGroupCategory(id: "", name: '');
          }
        })
        .toList()
        .cast<T>();
  }

  @override
  Future<List<Map<String, Object?>>> fetchRawQuery(String sql,
      [List<Object?>? arguments]) async {
    List<Map<String, dynamic>> result =
        await _database?.rawQuery(sql, arguments) ?? [];

    return result;
  }

  @override
  insert(DBObject object) async {
    await _database?.insert(object.className(), object.toMap());

    print('🦊🦊INSERT ${object.className()} ${object.toMap()}');

    // 소비 추가할때, 보정
    if (object is DBSpend) {
      // noSpend_test.dart
      await deleteNoSpendIfNoSpend(object);
      await deleteNoSpendIfSpend(object);
      await deleteDuplicatedNoSpend(object);
    }
  }

  @override
  delete(DBObject object) async {
    String id = object.toMap()['id'];
    await _database
        ?.delete(object.className(), where: 'id = ?', whereArgs: [id]);
    print('🦊🦊DELETE ${object.className()} ${object.toMap()}');
  }

  @override
  update(DBObject object) async {
    String id = object.toMap()['id'];
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
      queryForCreateDBGroupMonth(),
      queryForCreateDBGroupCategory(),
      queryForCreateDBSpend(),
      queryForCreateDBSpendCategory(),
      queryForCreateSpendCategoryIndexDBSpend(),
      queryForCreateGroupCategoryIndexDBSpend(),
    ];

    for (String query in querys) {
      await db.execute(query);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    this._oldVersion = oldVersion;
    print("👩🏻‍🦳👩🏻‍DB SCHEME old version : ${_oldVersion}");
    print("👩🏻‍🦳👩🏻‍DB SCHEME NEW version : ${newVersion}");

    // if (oldVersion == 1) {
    //   print("🔥 MIGRATION DB TABLE 1 .........");
    //   await this.migration1(db);
    //   await this.migration2(db);
    // } else if (oldVersion == 2) {
    //   print("🔥 MIGRATION DB TABLE 2 .........");
    //   await this.migration2(db);
    // }
  }
}
