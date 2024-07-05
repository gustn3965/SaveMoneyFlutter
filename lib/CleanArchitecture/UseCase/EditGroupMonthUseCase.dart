
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

abstract class EditGroupMonthUseCase {
  Future<void> updateGroupMonth(GroupMonth groupMonth);

  Future<void> deleteGroupMonth(GroupMonth groupMonth);
}

class MockEditGroupMonthUseCase extends EditGroupMonthUseCase {

  @override
  Future<void> updateGroupMonth(GroupMonth groupMonth) async {
    for (GroupMonth month in mockGroupMonthList) {
      if (month.identity == groupMonth.identity) {
        month.plannedBudget = groupMonth.plannedBudget;
      }
    }
  }
  @override
  Future<void> deleteGroupMonth(GroupMonth groupMonth) async {

    for (int index = 0; index < mockGroupMonthList.length; index ++) {
      GroupMonth month = mockGroupMonthList[index];
      if (month.identity == groupMonth.identity) {
        mockGroupMonthList.removeAt(index);
        return;
      }
    }
  }
}

class RepoEditGroupMonthUseCase extends EditGroupMonthUseCase {

  Repository repository;

  RepoEditGroupMonthUseCase(this.repository);

  @override
  Future<void> updateGroupMonth(GroupMonth groupMonth) async {
await repository.updateGroupMonth(groupMonth);
  }
  @override
  Future<void> deleteGroupMonth(GroupMonth groupMonth) async {
await repository.deleteGroupMonth(groupMonth);
  }
}