import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';

import '../../Extension/DateTime+Extension.dart';
import '../Domain/Entity/GroupMonth.dart';

import 'MockDataSet.dart';

abstract class GroupMonthFetchUseCase {
  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date);

  Future<GroupMonth?> fetchGroupMonthByGroupId(String? groupId);

  Future<List<GroupMonth>> fetchGroupMonthByGroupIds(List<String> groupIds);

  Future<GroupMonth?> fetchGroupMonthByCategoryIdAndDateTime(
      String groupCategoryId, DateTime date);

  Future<List<GroupMonth>> fetchGroupMonthByCategoryId(String groupCategoryId);
}

class MockGroupMonthFetchUseCase extends GroupMonthFetchUseCase {
  @override
  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date) async {
    // 예시 데이터 리스트 반환

    await Future.delayed(const Duration(milliseconds: 100));

    List<GroupMonth> list = [];
    for (GroupMonth groupMonth in mockGroupMonthList) {
      if (isEqualDateMonth(groupMonth.date, date)) {
        list.add(groupMonth);
      }
    }
    return list;
  }

  @override
  Future<GroupMonth?> fetchGroupMonthByGroupId(String? groupId) async {
    // 예시 데이터 반환
    await Future.delayed(
        const Duration(milliseconds: 100)); // 비동기 처리를 위해 await 사용

    for (var group in mockGroupMonthList) {
      if (group.identity == groupId) {
        print(group.spendList.length);
        return group;
      }
    }
    return null;
  }

  Future<List<GroupMonth>> fetchGroupMonthByGroupIds(
      List<String> groupIds) async {
    List<GroupMonth> groups = [];
    await Future.delayed(
        const Duration(milliseconds: 100)); // 비동기 처리를 위해 await 사용

    for (GroupMonth group in mockGroupMonthList) {
      if (groupIds.contains(group.identity)) {
        groups.add(group);
      }
    }
    return groups;
  }

  @override
  Future<GroupMonth?> fetchGroupMonthByCategoryIdAndDateTime(
      String groupCategoryId, DateTime date) async {
    for (var group in mockGroupMonthList) {
      if (group.groupCategory.identity == groupCategoryId &&
          isEqualDateMonth(group.date, date)) {
        return group;
      }
    }

    return null;
  }

  @override
  Future<List<GroupMonth>> fetchGroupMonthByCategoryId(
      String groupCategoryId) async {
    List<GroupMonth> groupMonths = [];
    for (var group in mockGroupMonthList) {
      if (group.groupCategory.identity == groupCategoryId) {
        groupMonths.add(group);
      }
    }

    return groupMonths;
  }
}

class RepoGroupMonthFetchUseCase extends GroupMonthFetchUseCase {
  Repository repository;

  RepoGroupMonthFetchUseCase(this.repository);

  @override
  Future<List<GroupMonth>> fetchGroupMonthByCategoryId(
      String groupCategoryId) async {
    return await repository.fetchGroupMonthByCategoryId(groupCategoryId);
  }

  @override
  Future<GroupMonth?> fetchGroupMonthByCategoryIdAndDateTime(
      String groupCategoryId, DateTime date) async {
    return await repository.fetchGroupMonthByCategoryIdAndDateTime(
        groupCategoryId, date);
  }

  @override
  Future<GroupMonth?> fetchGroupMonthByGroupId(String? groupId) async {
    return await repository.fetchGroupMonthByGroupId(groupId);
  }

  @override
  Future<List<GroupMonth>> fetchGroupMonthByGroupIds(
      List<String> groupIds) async {
    return await repository.fetchGroupMonthByGroupIds(groupIds);
  }

  @override
  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date) async {
    List<GroupMonth> groupMonths = await repository.fetchGroupMonthList(date);
    return groupMonths..sort((a, b) => a.groupCategory.name.compareTo(b.groupCategory.name));
  }
}
