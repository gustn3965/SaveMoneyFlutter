import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';
import 'MockDataSet.dart';

abstract class EditSpendUseCase {
  Future<bool> editSpend(Spend spend);

  Future<bool> deleteSpend(String spendId);
}

class MockEditSpendUseCase extends EditSpendUseCase {
  @override
  Future<bool> editSpend(Spend editSpend) async {
    bool didDelete = false;
    for (GroupMonth month in mockGroupMonthList) {
      for (int index = 0; index < month.spendList.length; index++) {
        if (month.spendList[index].identity == editSpend.identity) {
          month.spendList.removeAt(index);
          didDelete = true;
          break;
        }
      }

      if (didDelete) {
        break;
      }
    }

    for (GroupMonth month in mockGroupMonthList) {
      if (month.groupCategory.identity == editSpend.groupCategory.identity) {
        month.spendList.add(editSpend);
        break;
      }
    }

    return true;
  }

  @override
  Future<bool> deleteSpend(String spendId) async {
    bool didDelete = false;
    for (GroupMonth month in mockGroupMonthList) {
      for (int index = 0; index < month.spendList.length; index++) {
        if (month.spendList[index].identity == spendId) {
          month.spendList.removeAt(index);
          didDelete = true;
          break;
        }
      }

      if (didDelete) {
        break;
      }
    }
    return true;
  }
}
