import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../Data/Repository/Repository.dart';
import '../Domain/Entity/GroupCategory.dart';
import '../Domain/Entity/GroupMonth.dart';

abstract class AddGroupMonthUseCase {
  Future<void> addGroupMonth(
      GroupCategory groupCategory, int plannedBudget, DateTime date);
}

class MockAddGroupMonthUseCase extends AddGroupMonthUseCase {
  @override
  Future<void> addGroupMonth(
      GroupCategory groupCategory, int plannedBudget, DateTime date) async {
    GroupMonth newMonth = GroupMonth(
      spendList: [],
      plannedBudget: plannedBudget,
      date: date,
      days: daysInDateTime(date),
      groupCategory: groupCategory,
      identity: generateUniqueId(),
    );
    mockGroupMonthList.add(newMonth);
  }
}

class RepoAddGroupMonthUseCase extends AddGroupMonthUseCase {
  Repository repository;

  RepoAddGroupMonthUseCase(this.repository);

  @override
  Future<void> addGroupMonth(
      GroupCategory groupCategory, int plannedBudget, DateTime date) async {
    // category도 만들어줘야함.
    await repository.addGroupMonth(groupCategory, plannedBudget, date);
  }
}
