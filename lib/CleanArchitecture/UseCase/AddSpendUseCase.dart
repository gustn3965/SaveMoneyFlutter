import '../../Extension/DateTime+Extension.dart';
import '../../Extension/int+Extension.dart';
import '../Data/Repository/Repository.dart';
import '../Domain/Entity/GroupCategory.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';
import '../Domain/Entity/SpendCategory.dart';

import 'MockDataSet.dart';

abstract class AddSpendUseCase {
  // 무소비를 추가한경우, 1. 그날에 소비된 내역 삭제해주기. 2. 그날에 무소비있으면 무시.
  // 소비된 내역 추가한경우, 1. 그날에 무소비 삭제해주기.
  Future<bool> addSpend(Spend spend);
}

class MockAddSpendUseCase extends AddSpendUseCase {
  @override
  Future<bool> addSpend(Spend newSpend) async {
    for (GroupMonth month in mockGroupMonthList) {
      if (month.identity != newSpend.groupMonthId) {
        continue;
      }

      if (newSpend.spendType == SpendType.nonSpend) {
        removeRealSpend(month, newSpend);

        if (hasAlreadyNonSpend(month, newSpend)) {
          return true;
        }
      } else if (newSpend.spendType == SpendType.realSpend) {
        removeNonSpend(month, newSpend);
      }

      month.spendList.add(newSpend);
    }

    return true;
  }

  void removeRealSpend(GroupMonth month, Spend newSpend) {
    for (int index = 0; index < month.spendList.length; index++) {
      Spend spend = month.spendList[index];
      if (isEqualDateMonthAndDay(spend.date, newSpend.date) &&
          spend.spendType == SpendType.realSpend) {
        month.spendList.remove(spend);
      }
    }
  }

  void removeNonSpend(GroupMonth month, Spend newSpend) {
    for (int index = 0; index < month.spendList.length; index++) {
      Spend spend = month.spendList[index];
      if (isEqualDateMonthAndDay(spend.date, newSpend.date) &&
          spend.spendType == SpendType.nonSpend) {
        month.spendList.remove(spend);
      }
    }
  }

  bool hasAlreadyNonSpend(GroupMonth month, Spend newSpend) {
    for (Spend spend in month.spendList) {
      if (isEqualDateMonthAndDay(spend.date, newSpend.date) &&
          spend.spendType == SpendType.nonSpend) {
        return true;
      }
    }
    return false;
  }
}

class RepoAddSpendUseCase extends AddSpendUseCase {
  Repository repository;

  RepoAddSpendUseCase(this.repository);

  @override
  Future<bool> addSpend(Spend spend) async {
    return await repository.addSpend(spend);
  }
}
