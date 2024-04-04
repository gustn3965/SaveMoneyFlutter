import '../../Extension/DateTime+Extension.dart';
import '../../Extension/int+Extension.dart';
import '../Domain/Entity/GroupCategory.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';
import '../Domain/Entity/SpendCategory.dart';

import 'MockDataSet.dart';

abstract class AddSpendUseCase {
  Future<bool> addSpend(Spend spend);
}

class MockAddSpendUseCase extends AddSpendUseCase {
  @override
  Future<bool> addSpend(Spend spend) async {
    for (GroupMonth month in mockGroupMonthList) {
      if (month.groupCategory.identity == spend.groupCategory.identity) {
        month.spendList.add(spend);
      }
    }

    return true;
  }
}
