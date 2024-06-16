import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

import '../Data/Repository/Repository.dart';

abstract class EditGroupCategoryUseCase {
  Future<void> updateGroupCategory(GroupCategory groupCategory);

  Future<void> deleteGroupCategory(GroupCategory groupCategory);
}

class MockEditGroupCategoryUseCase extends EditGroupCategoryUseCase {
  @override
  Future<void> updateGroupCategory(GroupCategory groupCategory) async {
    for (GroupCategory mockgroupCategory in mockCategoryList) {
      if (mockgroupCategory.identity == groupCategory.identity) {
        mockgroupCategory.name = groupCategory.name;
      }
    }
  }

  @override
  Future<void> deleteGroupCategory(GroupCategory groupCategory) async {
    int i = 0;
    while (i < mockGroupMonthList.length) {
      GroupMonth groupMonth = mockGroupMonthList[i];
      if (groupMonth.groupCategory.identity == groupCategory.identity) {
        mockGroupMonthList.removeAt(i);
      } else {
        i += 1;
      }
    }
  }
}

class RepoEditGroupCategoryUseCase extends EditGroupCategoryUseCase {
  Repository repository;
  RepoEditGroupCategoryUseCase(this.repository);
  @override
  Future<void> updateGroupCategory(GroupCategory groupCategory) async {
    await repository.updateGroupCategory(groupCategory);
  }

  @override
  Future<void> deleteGroupCategory(GroupCategory groupCategory) async {
    await repository.deleteGroupCategory(groupCategory);
  }
}
