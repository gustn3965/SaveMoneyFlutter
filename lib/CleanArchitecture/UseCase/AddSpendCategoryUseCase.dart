import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

abstract class AddSpendCategoryUseCase {
  // 무소비를 추가한경우, 1. 그날에 소비된 내역 삭제해주기. 2. 그날에 무소비있으면 무시.
  // 소비된 내역 추가한경우, 1. 그날에 무소비 삭제해주기.
  Future<void> addSpendCategory(SpendCategory spend);
  Future<bool> checkHasAlreadySpendCategory(String categoryName);
}

class MockAddSpendCategoryUseCase extends AddSpendCategoryUseCase {
  @override
  Future<void> addSpendCategory(SpendCategory spend) async {
    mockSpendCategoryList.add(spend);
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

class RepoAddSpendCategoryUseCase extends AddSpendCategoryUseCase {
  Repository repository;

  RepoAddSpendCategoryUseCase(this.repository);

  @override
  Future<void> addSpendCategory(SpendCategory spend) async {
    await repository.addSpendCategory(spend);
  }

  @override
  Future<bool> checkHasAlreadySpendCategory(String categoryName) async {
    return await repository.checkHasAlreadySpendCategory(categoryName);
  }
}
