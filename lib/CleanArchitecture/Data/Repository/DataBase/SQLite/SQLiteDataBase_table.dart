import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/SQLite/SQLiteDataBase.dart';

extension SQLiteDataBaseTable on SQLiteDataBase {
  String queryForCreateDBGroupMonth() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS DBGroupMonth (
        id                          TEXT NOT NULL,
        date                        INTEGER NOT NULL,
        groupCategoryId             TEXT NOT NULL,
        plannedBudget               INTEGER NOT NULL,
        PRIMARY KEY(id, date, groupCategoryId)
        )
    ''';
    return sql;
  }

  String queryForCreateGroupCategoryIndexDBGroupMonth() {
    String sql = '''
            CREATE INDEX IF NOT EXISTS idx_groupCategoryId
        ON DBSpend (groupCategoryId)
  ''';
    return sql;
  }

  String queryForCreateDBSpend() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS DBSpend (
        id                           TEXT NOT NULL,
        date                         INTEGER NOT NULL,
        spend                        INTEGER NOT NULL,
        groupMonthId                 TEXT NOT NULL,
        groupCategoryId              TEXT NOT NULL,
        spendCategoryId              TEXT NOT NULL,
        spendType                    INTEGER NOT NULL,
        description                  TEXT NOT NULL,
        PRIMARY KEY(id)
        )
  ''';
    return sql;
  }

  String queryForCreateSpendCategoryIndexDBSpend() {
    String sql = '''
            CREATE INDEX IF NOT EXISTS idx_spendCategoryId
        ON DBSpend (spendCategoryId)
  ''';
    return sql;
  }

  String queryForCreateGroupCategoryIndexDBSpend() {
    String sql = '''
        CREATE INDEX IF NOT EXISTS idx_groupCategoryId
        ON DBSpend (groupCategoryId)
   ''';
    return sql;
  }

  String queryForCreateDBGroupCategory() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS DBGroupCategory (
        id                             TEXT NOT NULL,
        name                           TEXT NOT NULL,
        PRIMARY KEY(id)
        )
    ''';
    return sql;
  }

  String queryForCreateDBSpendCategory() {
    String sql = '''
        CREATE TABLE IF NOT EXISTS DBSpendCategory (
        id                             TEXT NOT NULL,
        name                           TEXT NOT NULL,
        countOfSpending                INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY(id)
        )
    ''';
    return sql;
  }
}
