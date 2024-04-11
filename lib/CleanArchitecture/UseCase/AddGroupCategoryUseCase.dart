import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

abstract class AddGroupCategoryUseCase {
  Future<GroupCategory> addGroupCategory(String groupCategoryName);
}

class MockAddGroupCategoryUseCase extends AddGroupCategoryUseCase {
  @override
  Future<GroupCategory> addGroupCategory(String groupCategoryName) async {
    GroupCategory newGroupCategory = GroupCategory(
        name: groupCategoryName,
        identity: indexDateIdFromDateTime(DateTime.now()));

    mockCategoryList.add(newGroupCategory);
    return newGroupCategory;
  }
}
