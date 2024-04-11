import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../Domain/Entity/GroupCategory.dart';
import 'MockDataSet.dart';

abstract class GroupCategoryFetchUseCase {
  Future<List<GroupCategory>> fetchGroupCategoryList(DateTime date);

  Future<List<GroupCategory>> fetchAllGroupCategoryList();
}

class MockGroupCategoryFetchUseCase extends GroupCategoryFetchUseCase {
  @override
  Future<List<GroupCategory>> fetchGroupCategoryList(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 100));

    Set<GroupCategory> set = {};
    for (GroupMonth groupMonth in mockGroupMonthList) {
      if (isEqualDateMonth(groupMonth.date, date)) {
        set.add(groupMonth.groupCategory);
      }
    }
    return set.toList();
  }

  @override
  Future<List<GroupCategory>> fetchAllGroupCategoryList() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return mockCategoryList;
  }
}
