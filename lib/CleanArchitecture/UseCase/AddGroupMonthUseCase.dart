import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

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
      groupCategory: groupCategory,
      identity: indexDateIdFromDateTime(date),
    );
    mockGroupMonthList.add(newMonth);
  }
}
