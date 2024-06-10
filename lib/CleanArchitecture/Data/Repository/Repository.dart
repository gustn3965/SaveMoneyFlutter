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
    List<DBSpendCategory> dbSpendCategories =
        await databaseController.fetch(DBSpendCategory.staticClassName());

    List<SpendCategory> spendCategories = [];

    for (DBSpendCategory db in dbSpendCategories) {
      SpendCategory spendCategory =
          SpendCategory(name: db.name, identity: db.id);
      spendCategories.add(spendCategory);
    }

    print(spendCategories);
    return spendCategories;
  }

  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      List<String> groupCategoryIds) async {
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

    List<DBSpendCategory> spendCategoryList = await databaseController.fetch(
        DBSpendCategory.staticClassName(),
        where: "id IN ($spendCategoryIdsPlaceholders)",
        args: spendCategoryIds);

    List<SpendCategory> list = spendCategoryList.map((category) {
      return SpendCategory(name: category.name, identity: category.id);
    }).toList();

    return list;
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

  // Future<bool> addSpend(Spend spend) async {
  //   DBSpend(id: spend.identity, date: (spend.date.millisecondsSinceEpoch / 1000).toInt(), spend: spend.spend, groupMonthId: spend.groupCategory, groupCategoryId: groupCategoryId, spendCategoryId: spendCategoryId, spendType: spendType, description: description)
  // }
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
        plannedBudget: groupMonth.expectedSpend,
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

      List<DBGroupCategory> groupCategories = await databaseController.fetch(
          DBGroupCategory.staticClassName(),
          where: "id = ? ",
          args: [spend.groupCategoryId]);
      GroupCategory groupCategory = GroupCategory(
          name: groupCategories.first.name, identity: groupCategories.first.id);

      SpendCategory? spendCategory = spendCatgories.map((spendCategory) {
        return SpendCategory(
            name: spendCategory.name, identity: spendCategory.id);
      }).firstOrNull;

      Spend newSpend = Spend(
          date: dateTimeFromSince1970Second(spend.date),
          spendMoney: spend.spend,
          groupCategory: groupCategory,
          spendCategory: spendCategory,
          identity: spend.id);
      spends.add(newSpend);
    }
    return spends;
  }
}
