import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../Data/Repository/Repository.dart';

abstract class AddGroupCategoryUseCase {
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;

  Future<GroupCategory> addGroupCategory(String groupCategoryName);
}

class MockAddGroupCategoryUseCase extends AddGroupCategoryUseCase {
  @override
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase =
      MockGroupCategoryFetchUseCase();

  @override
  Future<GroupCategory> addGroupCategory(String groupCategoryName) async {
    GroupCategory? hasCategory = await groupCategoryFetchUseCase
        .fetchGroupCategoryByName(groupCategoryName);
    if (hasCategory != null) {
      return hasCategory;
    }

    GroupCategory newGroupCategory =
        GroupCategory(name: groupCategoryName, identity: generateUniqueId());

    mockCategoryList.add(newGroupCategory);
    return newGroupCategory;
  }
}

class RepoAddGroupCategoryUseCase extends AddGroupCategoryUseCase {
  Repository repository;

  RepoAddGroupCategoryUseCase(this.repository);

  @override
  Future<GroupCategory> addGroupCategory(String groupCategoryName) async {
    return repository.addGroupCategory(groupCategoryName);
  }
}
