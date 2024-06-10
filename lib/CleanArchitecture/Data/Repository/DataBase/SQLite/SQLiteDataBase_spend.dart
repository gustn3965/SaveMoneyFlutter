import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBSpend.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/SQLite/SQLiteDataBase.dart';

extension SQLiteDataBaseSpend on SQLiteDataBase {
  // noSpend_test.dart

  // (같은 그룹일때) 이전에 소비등록되어있었고, 무소비를 추가하면, 무소비는 등록안되게 무소비삭제해준다.
  deleteNoSpendIfNoSpend(DBSpend spendDay) async {
    if (spendDay.spendType == DBSpendType.noSpend) {
      List<DBSpend> list = await this.fetch(DBSpend.staticClassName(),
          where: 'date = ? AND spendType = ? AND groupCategoryId = ?',
          args: [
            spendDay.date,
            DBSpendType.spend.rawValue,
            spendDay.groupCategoryId
          ]);
      if (list.isNotEmpty) {
        await this.delete(spendDay);
      }
    }
  }

  // (같은 그룹일때) 소비 추가할때, 이전에 무소비로 되어있는 NTSpendDay 삭제.
  deleteNoSpendIfSpend(DBSpend spendDay) async {
    if (spendDay.spendType == DBSpendType.spend) {
      List<DBSpend> list = await this.fetch(DBSpend.staticClassName(),
          where: 'date = ? AND spendType = ? AND groupCategoryId = ?',
          args: [
            spendDay.date,
            DBSpendType.noSpend.rawValue,
            spendDay.groupCategoryId
          ]);
      if (list.isNotEmpty) {
        await this.delete(list.first);
      }
    }
  }

  // noSpend_test.dart
  // (같은 그룹일때) 무소비 두번추가하면 이전 무소비는 삭제
  deleteDuplicatedNoSpend(DBSpend spendDay) async {
    if (spendDay.spendType == DBSpendType.noSpend) {
      List<DBSpend> list = await this.fetch(DBSpend.staticClassName(),
          where: 'date = ? AND spendType = ? AND groupCategoryId = ? ',
          args: [
            spendDay.date,
            DBSpendType.noSpend.rawValue,
            spendDay.groupCategoryId
          ]);

      if (list.length > 1) {
        await this.delete(list.last);
      }
    }
  }
}
