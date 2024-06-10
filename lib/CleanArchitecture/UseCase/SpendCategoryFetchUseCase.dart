import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';

import '../Domain/Entity/Spend.dart';
import '../Domain/Entity/SpendCategory.dart';
import 'MockDataSet.dart';

abstract class SpendCategoryFetchUseCase {
  Future<List<SpendCategory>> fetchSpendCategoryList();
  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      List<String> groupCategoryIds);
}

class MockSpendCategoryFetchUseCase extends SpendCategoryFetchUseCase {
  @override
  Future<List<SpendCategory>> fetchSpendCategoryList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return mockSpendCategoryList;
  }

  @override
  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      List<String> groupCategoryIds) async {
    Set<SpendCategory> set = {};

    for (GroupMonth groupMonth in mockGroupMonthList) {
      if (groupCategoryIds.contains(groupMonth.groupCategory.identity) ==
          false) {
        continue;
      }
      for (Spend spend in groupMonth.spendList) {
        if (spend.spendCategory != null) {
          set.add(spend.spendCategory!);
        }
      }
    }
    return set.toList();
  }
}
