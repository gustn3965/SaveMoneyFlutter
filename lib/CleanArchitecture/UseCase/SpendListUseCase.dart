import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

import '../../Extension/DateTime+Extension.dart';
import '../Data/Repository/Repository.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';

abstract class SpendListUseCase {
  Future<List<Spend>> fetchDaySpendList(String groupId, DateTime date);
  Future<List<Spend>> fetchDaySpendLists(List<String> groupIds, DateTime date);
  Future<List<Spend>> fetchSpendList({
    required List<String> spendCategoryIds,
    required List<String> groupCategoryIds,
    required bool descending,
  });
  Future<List<Spend>> fetchSpendListGroupIds({
    required List<String> spendCategoryIds,
    required List<String> groupIds,
    required bool descending,
  });
  Future<List<Spend>> fetchSpendListBySpendCategoryId(
      {required String spendCategoryId, required bool descending});

  Future<Spend?> fetchSpend(String spendId);
}

class MockSpendListUseCase extends SpendListUseCase {
  @override
  Future<List<Spend>> fetchDaySpendList(String groupId, DateTime date) async {
    List<Spend> spendList = [];
    for (GroupMonth group in mockGroupMonthList) {
      if (group.identity == groupId) {
        for (Spend spend in group.spendList) {
          if (isEqualDateMonthAndDay(date, spend.date)) {
            spendList.add(spend);
          }
        }
      }
    }

    return spendList;
  }

  Future<List<Spend>> fetchDaySpendLists(
      List<String> groupIds, DateTime date) async {
    List<Spend> spendList = [];
    for (GroupMonth group in mockGroupMonthList) {
      if (groupIds.contains(group.identity)) {
        for (Spend spend in group.spendList) {
          if (isEqualDateMonthAndDay(date, spend.date)) {
            spendList.add(spend);
          }
        }
      }
    }

    return spendList;
  }

  @override
  Future<Spend?> fetchSpend(String spendId) async {
    for (GroupMonth group in mockGroupMonthList) {
      for (Spend spend in group.spendList) {
        if (spend.identity == spendId) {
          return spend;
        }
      }
    }
    return null;
  }

  @override
  Future<List<Spend>> fetchSpendList(
      {required List<String> spendCategoryIds,
      required List<String> groupCategoryIds,
      required bool descending}) async {
    List<Spend> spendList = [];
    for (GroupMonth group in mockGroupMonthList) {
      if (groupCategoryIds.contains(group.groupCategory.identity)) {
        for (Spend spend in group.spendList) {
          if (spend.spendCategory != null &&
              spendCategoryIds.contains(spend.spendCategory!.identity)) {
            spendList.add(spend);
          }
        }
      }
    }

    if (descending) {
      spendList.sort((a, b) => b.date.compareTo(a.date));
    } else {
      spendList.sort((a, b) => a.date.compareTo(b.date));
    }
    return spendList;
  }

  @override
  Future<List<Spend>> fetchSpendListBySpendCategoryId(
      {required String spendCategoryId, required bool descending}) async {
    List<Spend> spendList = [];
    for (GroupMonth group in mockGroupMonthList) {
      for (Spend spend in group.spendList) {
        if (spend.spendCategory != null &&
            spend.spendCategory!.identity == spendCategoryId) {
          spendList.add(spend);
        }
      }
    }

    if (descending) {
      spendList.sort((a, b) => b.date.compareTo(a.date));
    } else {
      spendList.sort((a, b) => a.date.compareTo(b.date));
    }

    return spendList;
  }

  @override
  Future<List<Spend>> fetchSpendListGroupIds({
    required List<String> spendCategoryIds,
    required List<String> groupIds,
    required bool descending,
  }) async  {
    List<Spend> spendList = [];
    for (GroupMonth group in mockGroupMonthList) {
      if (groupIds.contains(group.identity)) {
        for (Spend spend in group.spendList) {
          if (spend.spendCategory != null &&
              spendCategoryIds.contains(spend.spendCategory!.identity)) {
            spendList.add(spend);
          }
        }
      }
    }

    if (descending) {
      spendList.sort((a, b) => b.date.compareTo(a.date));
    } else {
      spendList.sort((a, b) => a.date.compareTo(b.date));
    }
    return spendList;
  }
}

class RepoSpendListUseCase extends SpendListUseCase {
  Repository repository;

  RepoSpendListUseCase(this.repository);

  @override
  Future<List<Spend>> fetchDaySpendList(String groupId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return await repository.fetchDaySpendList(groupId, date);
  }

  @override
  Future<List<Spend>> fetchDaySpendLists(
      List<String> groupIds, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return await repository.fetchDaySpendLists(groupIds, date);
  }

  @override
  Future<Spend?> fetchSpend(String spendId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return await repository.fetchSpend(spendId);
  }

  @override
  Future<List<Spend>> fetchSpendList(
      {required List<String> spendCategoryIds,
      required List<String> groupCategoryIds,
      required bool descending}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return await repository.fetchSpendList(
        spendCategoryIds: spendCategoryIds,
        groupCategoryIds: groupCategoryIds,
        descending: descending);
  }

  @override
  Future<List<Spend>> fetchSpendListBySpendCategoryId(
      {required String spendCategoryId, required bool descending}) async {
    return await repository.fetchSpendListBySpendCategoryId(
        spendCategoryId: spendCategoryId, descending: descending);
  }

  @override
  Future<List<Spend>> fetchSpendListGroupIds({
    required List<String> spendCategoryIds,
    required List<String> groupIds,
    required bool descending,
  }) async  {
return await repository.fetchSpendListGroupIds(spendCategoryIds: spendCategoryIds, groupIds: groupIds, descending: descending);
  }
}
