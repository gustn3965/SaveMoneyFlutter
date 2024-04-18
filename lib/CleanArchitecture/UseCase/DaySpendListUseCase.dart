import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

import '../../Extension/DateTime+Extension.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';

abstract class DaySpendListUseCase {
  Future<List<Spend>> fetchDaySpendList(int groupId, DateTime date);
}

class MockDaySpendListUseCase extends DaySpendListUseCase {
  @override
  Future<List<Spend>> fetchDaySpendList(int groupId, DateTime date) async {
    List<Spend> spendList = [];
    for (GroupMonth group in mockGroupMonthList) {
      if (group.identity == groupId) {
        for (Spend spend in group.spendList) {
          if (isEqualDateMonthAndDay(date, spend.date)) {
            spendList.add(spend);
          }
        }
      }
    }

    return spendList;
  }
}
