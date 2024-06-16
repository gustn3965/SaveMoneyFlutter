import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/Spend.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

abstract class EditSpendCategoryUseCase {
  Future<void> updateSpendCategory(SpendCategory spendCategory);

  Future<void> deleteSpendCategory(SpendCategory spendCategory);
}

class MockEditSpendCategoryUseCase extends EditSpendCategoryUseCase {
  @override
  Future<void> updateSpendCategory(SpendCategory spendCategory) async {
    for (int i = 0; i < mockSpendCategoryList.length; i++) {
      SpendCategory mockSpendCategory = mockSpendCategoryList[i];
      if (mockSpendCategory.identity == spendCategory.identity) {
        mockSpendCategoryList[i] = spendCategory;
        return;
      }
    }
  }

  @override
  Future<void> deleteSpendCategory(SpendCategory spendCategory) async {
    for (int i = 0; i < mockSpendCategoryList.length; i++) {
      SpendCategory mockSpendCategory = mockSpendCategoryList[i];
      if (mockSpendCategory.identity == spendCategory.identity) {
        for (GroupMonth groupMonth in mockGroupMonthList) {
          // spend도 삭제.
          int y = 0;
          while (y < groupMonth.spendList.length) {
            Spend spend = groupMonth.spendList[y];
            if (spend.spendCategory?.identity == spendCategory.identity) {
              groupMonth.spendList.removeAt(y);
            } else {
              y += 1;
            }
          }
        }

        mockSpendCategoryList.removeAt(i);
        return;
      }
    }
  }
}

class RepoEditSpendCategoryUseCase extends EditSpendCategoryUseCase {
  Repository repository;

  RepoEditSpendCategoryUseCase(this.repository);

  @override
  Future<void> updateSpendCategory(SpendCategory spendCategory) async {
    await repository.updateSpendCategory(spendCategory);
  }

  @override
  Future<void> deleteSpendCategory(SpendCategory spendCategory) async {
    await repository.deleteSpendCategory(spendCategory);
  }
}
