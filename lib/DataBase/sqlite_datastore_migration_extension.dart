import 'package:save_money_flutter/DataBase/sqlite_datastore.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Model/NTSpendCategory.dart';
import 'Model/NTSpendDay.dart';

extension SqliteControllerMigration on SqliteController {
  // DB 테이블 타입 마이그레이션
  Future<void> migration1(Database db) async {
    // 1. NTSpendCategory 테이블에 countOfSpending 컬럼 추가 쿼리 실행
    await db.execute(
        'ALTER TABLE NTSpendCategory ADD COLUMN countOfSpending INTEGER NOT NULL DEFAULT 0');

    print("🔥🔥 migration1  .........succeeded");
  }

  Future<void> migration2(Database db) async {
    // 2. NTSpendCategory 테이블에 countOfSpending 컬럼 추가 쿼리 실행
    await db.execute(
        'ALTER TABLE NTSpendDay ADD COLUMN spendType INTEGER NOT NULL DEFAULT 1');

    print("🔥🔥 migration2  .........succeeded");
  }

  // table읽어와서 수정해야하는 마이그레이션
  Future<void> queryMigration(int oldVersion) async {
    if (oldVersion == 1) {
      print("⚠️ MIGRATION QUERY 1 .........");

      await migration1Query();
      await migration2Query();
    } else if (oldVersion == 2) {
      print("⚠️ MIGRATION QUERY 2 .........");

      await migration2Query();
    }
  }

  // 1. db 테이블 NTSpendDay읽어와서 NTSpendCategory의 countOfSpending 증가시켜주기.
  Future<void> migration1Query() async {
    List<NTSpendCategory> categoryList =
        await fetch<NTSpendCategory>(NTSpendCategory.staticClassName());
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

    print("⚠️⚠️ migration1Query 1 ......... succeeded");
  }

  // 2. NTSpendDay읽어와서, 무소비인경우에만 spendType에 0으로 바꾸고, categoryId는 0으로 바꾸고,
  //    NTSpendCategory에 무소비인경우 삭제.
  Future<void> migration2Query() async {
    List<NTSpendCategory> categoryList = await fetch<NTSpendCategory>(
        NTSpendCategory.staticClassName(),
        where: "id = ?",
        args: [16697374578]); // 무소비

    if (categoryList.first != null) {
      List<NTSpendDay> spendList = await fetch(NTSpendDay.staticClassName());
      for (NTSpendDay spendDay in spendList) {
        if (spendDay.categoryId == categoryList.first.id) {
          // 무소비
          spendDay.spendType = SpendType.noSpend;
          spendDay.categoryId = 0;

          update(spendDay);
        }
      }

      delete(categoryList.first);
    }

    print("⚠️⚠️ migration2Query 2 ......... succeeded");
  }
}
