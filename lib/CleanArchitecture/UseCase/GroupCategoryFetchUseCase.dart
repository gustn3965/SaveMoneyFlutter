import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../Domain/Entity/GroupCategory.dart';

abstract class GroupCategoryFetchUseCase {
  Future<List<GroupCategory>> fetchGroupCategoryList(DateTime date);
}

class MockGroupCategoryFetchUseCase extends GroupCategoryFetchUseCase {
  @override
  Future<List<GroupCategory>> fetchGroupCategoryList(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (date.month == DateTime.now().month - 1) {
      return [category1];
    } else if (date.month == DateTime.now().month) {
      return [category1, category2, category3, category4];
    } else {
      return [category3, category4];
    }
  }

  GroupCategory category1 = GroupCategory(identity: 1, name: "자동차 및 교통비용");
  GroupCategory category2 = GroupCategory(identity: 2, name: "개인 비용");
  GroupCategory category3 = GroupCategory(identity: 3, name: "데이트 항목");
  GroupCategory category4 = GroupCategory(identity: 4, name: "저금 항목");
}
