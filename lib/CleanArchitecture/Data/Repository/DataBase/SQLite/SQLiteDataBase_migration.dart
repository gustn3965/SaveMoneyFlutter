import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBGroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBGroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBSpend.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBSpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/SQLite/SQLiteDataBase.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendCategory.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendDay.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

extension SQLiteDataBaseMirgation on SQLiteDataBase {
  // DB 테이블 타입 마이그레이션

  // table읽어와서 수정해야하는 마이그레이션
  Future<void> queryMigration(int oldVersion) async {
    await migration1Query();
  }

  Future<void> migration1Query() async {
    // await migrationQueryOldNTdbToDBdb();
    print("⚠️⚠️ migration1Query 1 ......... succeeded");
  }

  // 이전 test_database.db 마이그레이션 코드.
  Future<void> migrationQueryOldNTdbToDBdb() async {
    Map<int, String> groupCategoryMap = {};
    Map<int, String> spendCategoryMap = {};
    Map<int, String> groupMonthMap = {};

    List<NTSpendGroup> groupCategories =
        await beforeSql.fetch(NTSpendGroup.staticClassName());
    print("NTSpendGroup");
    print(
      "기존 ${groupCategories.length}",
    );

    for (NTSpendGroup groupCategory in groupCategories) {
      String key = generateUniqueId();
      DBGroupCategory newGroupCategory =
          DBGroupCategory(id: key, name: groupCategory.name);

      groupCategoryMap[groupCategory.id] = key;
      await insert(newGroupCategory);
    }

    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    List<NTSpendCategory> spendCategories =
        await beforeSql.fetch(NTSpendCategory.staticClassName());
    print("NTSpendCategory");
    print(
      "기존 ${spendCategories.length}",
    );

    for (NTSpendCategory category in spendCategories) {
      String key = generateUniqueId();
      DBSpendCategory newCategory =
          DBSpendCategory(id: key, name: category.name, countOfSpending: 0);
      spendCategoryMap[category.id] = key;
      await insert(newCategory);
    }

    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    List<NTMonth> months = await beforeSql.fetch(NTMonth.staticClassName());
    print("NTMonth");
    print(
      "기존 ${months.length}",
    );

    for (NTMonth month in months) {
      String key = generateUniqueId();
      String groupCategoryKey = groupCategoryMap[month.groupId]!;
      DBGroupMonth newGroupMonth = DBGroupMonth(
          id: key,
          date: month.date,
          groupCategoryId: groupCategoryKey,
          plannedBudget: month.expectedSpend);

      groupMonthMap[month.id] = key;
      await insert(newGroupMonth);
    }

    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    List<NTSpendDay> spends =
        await beforeSql.fetch(NTSpendDay.staticClassName());
    print("NTSpendDay");
    print(
      "기존 ${spends.length}",
    );

    for (NTSpendDay spend in spends) {
      String key = generateUniqueId();
      String groupMonthkey = groupMonthMap[spend.monthId]!;
      String groupCategoryKey = groupCategoryMap[spend.groupId]!;
      String spendCategoryKey = "";
      if (spendCategoryMap[spend.categoryId] != null) {
        spendCategoryKey = spendCategoryMap[spend.categoryId]!;
      }

      DBSpendType spendType = DBSpendType.spend;
      if (spend.spendType == SpendType.noSpend) {
        spendType = DBSpendType.noSpend;
      }
      DBSpend newSpend = DBSpend(
          id: key,
          date: spend.date,
          spend: spend.spend,
          groupMonthId: groupMonthkey,
          groupCategoryId: groupCategoryKey,
          spendCategoryId: spendCategoryKey,
          spendType: spendType,
          description: "");
      // groupMonthMap[spend.id] = key;

      List<DBSpendCategory> spendCaegorys = await fetch(
          DBSpendCategory.staticClassName(),
          where: "id = ? ",
          args: [spendCategoryKey]);
      if (spendCaegorys.firstOrNull != null) {
        DBSpendCategory spendCategory = spendCaegorys.first!;
        spendCategory.countOfSpending += 1;
        await update(spendCategory);
      }
      await insert(newSpend);
    }
  }
}
