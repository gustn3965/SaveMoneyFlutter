import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBGroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBGroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/DataBase/Model/DBSpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/Spend.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../Domain/Entity/GroupMonth.dart';
import 'DataBase/DataBaseProtocol.dart';
import 'DataBase/Model/DBSpend.dart';
import 'Remote/RemoteApiProtocol.dart';

class Repository {
  DataBaseProtocol databaseController;
  RemoteApiProtocol? remoteApiController;

  Repository(this.databaseController, this.remoteApiController);

  Future<List<SpendCategory>> fetchSpendCategoryList() async {
    List<DBSpendCategory> dbSpendCategories = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        orderBy: "countOfSpending DESC");

    List<SpendCategory> spendCategories = [];

    for (DBSpendCategory db in dbSpendCategories) {
      SpendCategory spendCategory = SpendCategory(
          name: db.name,
          identity: db.id,
          totalSpendindCount: db.countOfSpending);
      spendCategories.add(spendCategory);
    }

    print(spendCategories);
    return spendCategories;
  }

  Future<SpendCategory?> fetchSpendCategoryById(
      {required String spendCategoryId}) async {
    List<DBSpendCategory> spendCategoryList = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        where: "id = ? ",
        args: [spendCategoryId]);

    if (spendCategoryList.firstOrNull != null) {
      DBSpendCategory spendCategory = spendCategoryList.first;
      return SpendCategory(
          name: spendCategory.name,
          identity: spendCategory.id,
          totalSpendindCount: spendCategory.countOfSpending);
    }

    return null;
  }

  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      List<String> groupCategoryIds, bool exceptNoSpend) async {
    String groupCategoryIdsPlaceholders =
        groupCategoryIds.map((id) => '?').join(',');

    String sql = '''
    SELECT DISTINCT spendCategoryId
    FROM DBSpend
    WHERE groupCategoryId IN ($groupCategoryIdsPlaceholders)
  ''';

    List<Map<String, dynamic>> result =
        await databaseController.fetchRawQuery(sql, groupCategoryIds);

    List<String> spendCategoryIds =
        result.map((row) => row['spendCategoryId'] as String).toList();

    String spendCategoryIdsPlaceholders =
        spendCategoryIds.map((id) => '?').join(',');

    List<Object> args = spendCategoryIds;
    args.add(exceptNoSpend ? "1" : "0");

    List<DBSpendCategory> spendCategoryList = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        where:
            "id IN ($spendCategoryIdsPlaceholders) AND countOfSpending >= ? ",
        args: args,
        orderBy: "countOfSpending DESC");

    List<SpendCategory> list = spendCategoryList.map((category) {
      return SpendCategory(
          name: category.name,
          identity: category.id,
          totalSpendindCount: category.countOfSpending);
    }).toList();

    return list;
  }

  Future<void> updateSpendCategory(SpendCategory spendCategory) async {
    String spendCategoryId = spendCategory.identity;
    List<DBSpendCategory> spendCategoryList = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        where: "id = ? ",
        args: [spendCategoryId]);

    if (spendCategoryList.firstOrNull != null) {
      DBSpendCategory dbspendCategory = spendCategoryList.first;
      dbspendCategory.name = spendCategory.name;
      await databaseController.update(dbspendCategory);
    }
  }

  Future<void> deleteSpendCategory(SpendCategory spendCategory) async {
    String spendCateogryId = spendCategory.identity;
    List<DBSpend> spendList = await databaseController.fetch(
        DBSpend.staticClassName(),
        where: "spendCategoryId = ? ",
        args: [spendCateogryId]);

    // 관련 db spend 삭제.
    for (DBSpend spend in spendList) {
      await databaseController.delete(spend);
    }

    List<DBSpendCategory> spendCategoryList = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        where: "id = ? ",
        args: [spendCateogryId]);

    // db spendcategory 삭제.
    if (spendCategoryList.firstOrNull != null) {
      DBSpendCategory dbspendCategory = spendCategoryList.first;
      await databaseController.delete(dbspendCategory);
    }
  }

  Future<List<GroupCategory>> fetchAllGroupCategoryList() async {
    List<DBGroupCategory> groupCategories =
        await databaseController.fetch(DBGroupCategory.staticClassName());

    return groupCategories.map((group) {
      return GroupCategory(name: group.name, identity: group.id);
    }).toList();
  }

  Future<GroupCategory?> fetchGroupCategoryByName(String categoryName) async {
    List<DBGroupCategory> groupCategories = await databaseController.fetch(
        DBGroupCategory.staticClassName(),
        where: "name = ? ",
        args: [categoryName]);

    return groupCategories.map((category) {
      return GroupCategory(name: category.name, identity: category.id);
    }).firstOrNull;
  }

  Future<GroupCategory?> fetchGroupCategoryById(String categoryId) async {
    List<DBGroupCategory> groupCategories = await databaseController.fetch(
        DBGroupCategory.staticClassName(),
        where: "id = ? ",
        args: [categoryId]);

    return groupCategories.map((category) {
      return GroupCategory(name: category.name, identity: category.id);
    }).firstOrNull;
  }

  Future<List<GroupCategory>> fetchGroupCategoryList(DateTime date) async {
    String sql = '''
    SELECT DISTINCT groupCategoryId
    FROM DBGroupMonth
    WHERE date = ?
  ''';
    List<Map<String, dynamic>> result = await databaseController
        .fetchRawQuery(sql, [indexMonthDateIdFromDateTime(date).toString()]);

    List<String> groupCategoryIds =
        result.map((row) => row['groupCategoryId'] as String).toList();

    String groupCategoryIdsPlaceholders =
        groupCategoryIds.map((id) => '?').join(',');

    List<DBGroupCategory> groupCategoryList = await databaseController.fetch(
        DBGroupCategory.staticClassName(),
        where: "id IN ($groupCategoryIdsPlaceholders)",
        args: groupCategoryIds);

    return groupCategoryList.map((category) {
      return GroupCategory(name: category.name, identity: category.id);
    }).toList();
  }

  Future<List<GroupMonth>> fetchGroupMonthByCategoryId(
      String groupCategoryId) async {
    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "groupCategoryId = ? order by date DESC",
        args: [groupCategoryId]);

    List<GroupMonth> newGroupMonths = [];
    for (DBGroupMonth groupMonth in groupMonths) {
      GroupMonth newGroupMonth = await makeGroupMonthFromDB(groupMonth);
      newGroupMonths.add(newGroupMonth);
    }
    return newGroupMonths;
  }

  Future<GroupMonth?> fetchGroupMonthByCategoryIdAndDateTime(
      String groupCategoryId, DateTime date) async {
    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "groupCategoryId = ? AND date = ?",
        args: [groupCategoryId, indexMonthDateIdFromDateTime(date)]);

    if (groupMonths.isNotEmpty) {
      return await makeGroupMonthFromDB(groupMonths.first!);
    } else {
      return null;
    }
  }

  Future<GroupMonth?> fetchGroupMonthByGroupId(String? groupId) async {
    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "id = ? ",
        args: [groupId]);
    if (groupMonths.isNotEmpty) {
      return await makeGroupMonthFromDB(groupMonths.first!);
    } else {
      return null;
    }
  }

  Future<List<GroupMonth>> fetchGroupMonthByGroupIds(
      List<String> groupIds) async {
    String groupIdsPlaceholders = groupIds.map((id) => '?').join(',');

    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "id IN ($groupIdsPlaceholders) ",
        args: groupIds);
    List<GroupMonth> newGroupMonths = [];
    for (DBGroupMonth groupMonth in groupMonths) {
      GroupMonth newGroupMonth = await makeGroupMonthFromDB(groupMonth);
      newGroupMonths.add(newGroupMonth);
    }
    return newGroupMonths;
  }

  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date) async {
    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "date = ? ",
        args: [indexMonthDateIdFromDateTime(date)]);

    List<GroupMonth> newGroupMonths = [];
    for (DBGroupMonth groupMonth in groupMonths) {
      GroupMonth newGroupMonth = await makeGroupMonthFromDB(groupMonth);
      newGroupMonths.add(newGroupMonth);
    }
    return newGroupMonths;
  }

  Future<List<Spend>> fetchDaySpendList(String groupId, DateTime date) async {
    List<DBSpend> spendList = await databaseController.fetch(
        DBSpend.staticClassName(),
        where: "groupMonthId = ? AND date = ? ",
        args: [groupId, indexMonthAndDayIdFromDateTime(date)]);

    return await makeSpendFromDB(spendList);
  }

  Future<List<Spend>> fetchDaySpendLists(
      List<String> groupIds, DateTime date) async {
    String groupIdsPlaceholders = groupIds.map((id) => '?').join(',');

    DateTime maxDate = dateTimeAfterDay(date, 1);
    List<Object> args = groupIds;
    args.add(indexMonthAndDayIdFromDateTime(date).toString());
    args.add(indexMonthAndDayIdFromDateTime(maxDate).toString());
    List<DBSpend> spendList = await databaseController.fetch(
        DBSpend.staticClassName(),
        where:
            "groupMonthId IN ($groupIdsPlaceholders) AND date >= ? AND date < ? AND spendType = 1",
        args: args);
    return await makeSpendFromDB(spendList);
  }

  Future<Spend?> fetchSpend(String spendId) async {
    List<DBSpend> spendList = await databaseController
        .fetch(DBSpend.staticClassName(), where: "id = ? ", args: [spendId]);

    List<Spend> spends = await makeSpendFromDB(spendList);
    return spends.firstOrNull;
  }

  Future<List<Spend>> fetchSpendList(
      {required String spendCategoryId,
      required List<String> groupCategoryIds,
      required bool descending}) async {
    String groupCategoryIdsPlaceholders =
        groupCategoryIds.map((id) => '?').join(',');

    List<Object> args = [spendCategoryId];
    args.addAll(groupCategoryIds);
    List<DBSpend> spendList = await databaseController.fetch(
        DBSpend.staticClassName(),
        where:
            "spendCategoryId = ? AND groupCategoryId IN ($groupCategoryIdsPlaceholders) order by date DESC",
        args: args);
    return await makeSpendFromDB(spendList);
  }

  @override
  Future<List<Spend>> fetchSpendListBySpendCategoryId(
      {required String spendCategoryId, required bool descending}) async {
    String oderBy = descending ? "date DESC" : "date";
    List<DBSpend> dbSpendList = await databaseController.fetch(
        DBSpend.staticClassName(),
        where: "spendCategoryId = ? ",
        args: [spendCategoryId],
        orderBy: oderBy);
    return makeSpendFromDB(dbSpendList);
  }

  Future<bool> addSpend(Spend spend) async {
    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "id = ? ",
        args: [spend.groupMonthId]);

    if (groupMonths.firstOrNull != null) {
      String groupCategoryId = groupMonths.first!.groupCategoryId;

      DBSpendType spendType = DBSpendType.spend;
      if (spend.spendType == SpendType.nonSpend) {
        spendType = DBSpendType.noSpend;
      }
      String spendCategoryId = spend.spendCategory?.identity ?? "";
      DBSpend dbSpend = DBSpend(
          id: spend.identity,
          date: (spend.date.millisecondsSinceEpoch / 1000).toInt(),
          spend: spend.spendMoney,
          groupMonthId: spend.groupMonthId,
          groupCategoryId: groupCategoryId,
          spendCategoryId: spendCategoryId,
          spendType: spendType,
          description: spend.description);
      await databaseController.insert(dbSpend);

      // SpendCategory add countOfSpending
      List<DBSpendCategory> spendCategorys = await databaseController.fetch(
          DBSpendCategory.staticClassName(),
          where: "id = ? ",
          args: [spendCategoryId]);
      if (spendCategorys.firstOrNull != null) {
        DBSpendCategory spendCategory = spendCategorys.first!;
        print(spendCategory.countOfSpending);
        spendCategory.countOfSpending += 1;
        await databaseController.update(spendCategory);
        print(spendCategory.countOfSpending);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteSpend(String spendId) async {
    List<DBSpend> spends = await databaseController
        .fetch(DBSpend.staticClassName(), where: "id = ? ", args: [spendId]);
    if (spends.firstOrNull != null) {
      DBSpend spend = spends.first;
      await databaseController.delete(spend);

      // spendCategory countof...
      String spendCategoryId = spend.spendCategoryId;
      List<DBSpendCategory> spendCategorys = await databaseController.fetch(
          DBSpendCategory.staticClassName(),
          where: "id = ? ",
          args: [spendCategoryId]);
      if (spendCategorys.firstOrNull != null) {
        DBSpendCategory spendCategory = spendCategorys.first!;
        print(spendCategory.countOfSpending);
        spendCategory.countOfSpending -= 1;
        if (spendCategory.countOfSpending < 0) {
          spendCategory.countOfSpending = 0;
        }
        await databaseController.update(spendCategory);
        print(spendCategory.countOfSpending);
      }

      return true;
    } else {
      return false;
    }
  }

  Future<bool> editSpend(Spend spend) async {
    List<DBGroupMonth> groupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "id = ? ",
        args: [spend.groupMonthId]);

    if (groupMonths.firstOrNull != null) {
      String groupCategoryId = groupMonths.first!.groupCategoryId;

      DBSpendType spendType = DBSpendType.spend;
      if (spend.spendType == SpendType.nonSpend) {
        spendType = DBSpendType.noSpend;
      }
      DBSpend dbSpend = DBSpend(
          id: spend.identity,
          date: (spend.date.millisecondsSinceEpoch / 1000).toInt(),
          spend: spend.spendMoney,
          groupMonthId: spend.groupMonthId,
          groupCategoryId: groupCategoryId,
          spendCategoryId: spend.spendCategory?.identity ?? "",
          spendType: spendType,
          description: spend.description);
      await databaseController.update(dbSpend);
      return true;
    } else {
      return false;
    }
  }

  Future<void> addGroupMonth(
      GroupCategory groupCategory, int plannedBudget, DateTime date) async {
    int intDate = indexMonthDateIdFromDateTime(date);
    DBGroupMonth dbGroupMonth = DBGroupMonth(
        id: generateUniqueId(),
        date: intDate,
        groupCategoryId: groupCategory.identity,
        plannedBudget: plannedBudget);

    await databaseController.insert(dbGroupMonth);
  }

  Future<GroupCategory> addGroupCategory(String groupCategoryName) async {
    DBGroupCategory groupCategory =
        DBGroupCategory(id: generateUniqueId(), name: groupCategoryName);
    await databaseController.insert(groupCategory);

    return GroupCategory(name: groupCategory.name, identity: groupCategory.id);
  }

  Future<void> addSpendCategory(SpendCategory spend) async {
    DBSpendCategory spendCategory = DBSpendCategory(
        id: spend.identity, name: spend.name, countOfSpending: 0);
    await databaseController.insert(spendCategory);
  }

  Future<bool> checkHasAlreadySpendCategory(String categoryName) async {
    List<DBSpendCategory> list = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        where: "name = ? ",
        args: [categoryName]);
    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateGroupCategory(GroupCategory groupCategory) async {
    List<DBGroupCategory> dbGroupCategorys = await databaseController.fetch(
        DBGroupCategory.staticClassName(),
        where: "id = ? ",
        args: [groupCategory.identity]);
    if (dbGroupCategorys.firstOrNull != null) {
      DBGroupCategory dbGroupCategory = dbGroupCategorys.first;
      dbGroupCategory.name = groupCategory.name;

      await databaseController.update(dbGroupCategory);
    }
  }

  Future<void> deleteGroupCategory(GroupCategory groupCategory) async {
    List<DBGroupMonth> dbGroupMonths = await databaseController.fetch(
        DBGroupMonth.staticClassName(),
        where: "groupCategoryId = ? ",
        args: [groupCategory.identity]);

    for (DBGroupMonth dbGroupMonth in dbGroupMonths) {
      List<DBSpend> dbSpendList = await databaseController.fetch(
          DBSpend.staticClassName(),
          where: "groupMonthId = ? ",
          args: [dbGroupMonth.id]);

      for (DBSpend dbSpend in dbSpendList) {
        await databaseController.delete(dbSpend);
      }

      await databaseController.delete(dbGroupMonth);
    }

    List<DBGroupCategory> dbGroupCategorys = await databaseController.fetch(
        DBGroupCategory.staticClassName(),
        where: "id = ? ",
        args: [groupCategory.identity]);
    if (dbGroupCategorys.firstOrNull != null) {
      DBGroupCategory dbGroupCategory = dbGroupCategorys.first;
      await databaseController.delete(dbGroupCategory);
    }
  }

  Future<void> updateGroupMonth(GroupMonth groupMonth) async {

    List<DBGroupMonth> dbGroupMonths = await databaseController.fetch(DBGroupMonth.staticClassName(), where: "id = ? ", args: [groupMonth.identity]);
    if (dbGroupMonths.firstOrNull != null) {
      DBGroupMonth dbGroupMonth = dbGroupMonths.first;
      dbGroupMonth.plannedBudget = groupMonth.plannedBudget;

      await databaseController.update(dbGroupMonth);
    }
  }
  Future<void> deleteGroupMonth(GroupMonth groupMonth) async {
    List<DBGroupMonth> dbGroupMonths = await databaseController.fetch(DBGroupMonth.staticClassName(), where: "id = ? ", args: [groupMonth.identity]);
    if (dbGroupMonths.firstOrNull != null) {
      DBGroupMonth dbGroupMonth = dbGroupMonths.first;

      await databaseController.delete(dbGroupMonth);
    }
  }
  // ------------------------------------------------------------
  // ------------------------------------------------------------
  // ------------------------------------------------------------
  // ------------------------------------------------------------
  // ------------------------------------------------------------
  // ------------------------------------------------------------

  Future<GroupMonth> makeGroupMonthFromDB(DBGroupMonth groupMonth) async {
    List<DBSpend> spendList = await databaseController.fetch(
        DBSpend.staticClassName(),
        where: "groupMonthId = ? ",
        args: [groupMonth.id]);
    List<DBGroupCategory> groupCategories = await databaseController.fetch(
        DBGroupCategory.staticClassName(),
        where: "id = ? ",
        args: [groupMonth.groupCategoryId]);
    GroupCategory groupCategory = groupCategories.map((groupCategory) {
      return GroupCategory(
          name: groupCategory.name, identity: groupCategory.id);
    }).first;

    List<Spend> spends = await makeSpendFromDB(spendList);

    DateTime dateTime = dateTimeFromSince1970Second(groupMonth.date);
    int days = daysInDateTime(dateTime);
    GroupMonth newGroupMonth = GroupMonth(
        spendList: spends,
        plannedBudget: groupMonth.plannedBudget,
        date: dateTime,
        days: days,
        groupCategory: groupCategory,
        identity: groupMonth.id);
    return newGroupMonth;
  }

  Future<List<Spend>> makeSpendFromDB(List<DBSpend> spendList) async {
    List<Spend> spends = [];
    for (DBSpend spend in spendList) {
      List<DBSpendCategory> spendCatgories = await databaseController.fetch(
          DBSpendCategory.staticClassName(),
          where: "id = ? ",
          args: [spend.spendCategoryId]);

      List<DBGroupMonth> groupMonths = await databaseController.fetch(
          DBGroupMonth.staticClassName(),
          where: "id = ? ",
          args: [spend.groupCategoryId]);

      SpendCategory? spendCategory = spendCatgories.map((spendCategory) {
        return SpendCategory(
            name: spendCategory.name, identity: spendCategory.id);
      }).firstOrNull;

      Spend newSpend = Spend(
          date: dateTimeFromSince1970Second(spend.date),
          spendMoney: spend.spend,
          groupMonthId: spend.groupMonthId,
          spendCategory: spendCategory,
          identity: spend.id,
          description: spend.description);
      spends.add(newSpend);
    }
    return spends;
  }
}
