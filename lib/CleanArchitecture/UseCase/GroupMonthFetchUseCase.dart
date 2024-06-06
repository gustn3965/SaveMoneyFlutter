import '../../Extension/DateTime+Extension.dart';
import '../Domain/Entity/GroupMonth.dart';

import 'MockDataSet.dart';

abstract class GroupMonthFetchUseCase {
  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date);

  Future<GroupMonth?> fetchGroupMonthByGroupId(String? groupId);

  Future<GroupMonth?> fetchGroupMonthByCategoryIdAndDateTime(
      String groupCategoryId, DateTime date);
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
    if (isEqualDateMonth(groupNow1.date, date)) {
      return [groupNow1, groupNow2, groupNow3];
    } else if (isEqualDateMonth(groupBefore1.date, date)) {
      return [groupBefore1, groupBefore2, groupBefore3];
    } else if (isEqualDateMonth(groupAfter1.date, date)) {
      return [groupAfter1, groupAfter2, groupAfter3];
    } else {
      return [];
    }
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
}
