import '../../Extension/DateTime+Extension.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';
import 'MockDataSet.dart';

abstract class EditSpendUseCase {
  // 무소비를 추가한경우, 1. 그날에 소비된 내역 삭제해주기. 2. 그날에 무소비있으면 무시.
  // 소비된 내역 추가한경우, 1. 그날에 무소비 삭제해주기.
  Future<bool> editSpend(Spend spend);

  Future<bool> deleteSpend(String spendId);
}

class MockEditSpendUseCase extends EditSpendUseCase {
  @override
  Future<bool> editSpend(Spend newSpend) async {
    bool didDelete = false;
    for (GroupMonth month in mockGroupMonthList) {
      if (month.groupCategory.identity != newSpend.groupCategory.identity) {
        continue;
      }

      if (newSpend.spendType == SpendType.nonSpend) {
        removeRealSpend(month, newSpend);
      } else {
        removeSameRealSpend(month, newSpend.identity);
      }
      month.spendList.add(newSpend);
    }
    return true;
  }

  @override
  Future<bool> deleteSpend(String spendId) async {
    for (GroupMonth month in mockGroupMonthList) {
      removeSameRealSpend(month, spendId);
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

  void removeSameRealSpend(GroupMonth month, String newSpendId) {
    for (int index = 0; index < month.spendList.length; index++) {
      Spend spend = month.spendList[index];
      if (spend.identity == newSpendId) {
        month.spendList.remove(spend);
      }
    }
  }
}
