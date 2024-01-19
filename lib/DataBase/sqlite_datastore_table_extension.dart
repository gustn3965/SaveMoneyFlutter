import 'sqlite_datastore.dart';

extension SqliteControllerTable on SqliteController {
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
        spendType                    INTEGER NOT NULL,
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
