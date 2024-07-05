import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/main.dart';

import '../Domain/Entity/Spend.dart';
import '../Domain/Entity/SpendCategory.dart';
import 'MockDataSet.dart';

abstract class SpendCategoryFetchUseCase {
  Future<List<SpendCategory>> fetchSpendCategoryList();
  Future<SpendCategory?> fetchSpendCategoryById(
      {required String spendCategoryId});
  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      {required List<String> groupCategoryIds, required bool exceptNoSpend});
  Future<bool> checkHasAlreadySpendCategory(String categoryName);
}

class MockSpendCategoryFetchUseCase extends SpendCategoryFetchUseCase {
  @override
  Future<List<SpendCategory>> fetchSpendCategoryList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return mockSpendCategoryList;
  }

  @override
  Future<SpendCategory?> fetchSpendCategoryById(
      {required String spendCategoryId}) async {
    for (SpendCategory spendCategory in mockSpendCategoryList) {
      if (spendCategory.identity == spendCategoryId) {
        return spendCategory;
      }
    }

    return null;
  }

  @override
  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      {required List<String> groupCategoryIds,
      required bool exceptNoSpend}) async {
    Set<SpendCategory> set = {};

    for (GroupMonth groupMonth in mockGroupMonthList) {
      if (groupCategoryIds.contains(groupMonth.groupCategory.identity) ==
          false) {
        continue;
      }
      for (Spend spend in groupMonth.spendList) {
        // exceptNoSpend는 mock에서 spend로 접근하고있으므로 필터링안해도됌
        if (spend.spendCategory != null) {
          set.add(spend.spendCategory!);
        }
      }
    }
    return set.toList();
  }

  @override
  Future<bool> checkHasAlreadySpendCategory(String categoryName) async {
    for (SpendCategory spendCategory in mockSpendCategoryList) {
      if (spendCategory.name == categoryName) {
        return true;
      }
    }
    return false;
  }
}

class RepoSpendCategoryFetchUseCase extends SpendCategoryFetchUseCase {
  Repository repository;

  RepoSpendCategoryFetchUseCase(this.repository);

  @override
  Future<List<SpendCategory>> fetchSpendCategoryList() async {
    return await repository.fetchSpendCategoryList();
  }

  @override
  Future<SpendCategory?> fetchSpendCategoryById(
      {required String spendCategoryId}) async {
    return await repository.fetchSpendCategoryById(
        spendCategoryId: spendCategoryId);
  }

  @override
  Future<List<SpendCategory>> fetchSpendCategoryListWithGroupCategoryIds(
      {required List<String> groupCategoryIds,
      required bool exceptNoSpend}) async {
    return await repository.fetchSpendCategoryListWithGroupCategoryIds(
        groupCategoryIds, exceptNoSpend);
  }

  @override
  Future<bool> checkHasAlreadySpendCategory(String categoryName) async {
    return await repository.checkHasAlreadySpendCategory(categoryName);
  }
}
