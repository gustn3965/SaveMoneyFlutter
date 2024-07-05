import 'GroupCategory.dart';
import 'Spend.dart';

class GroupMonth {
  List<Spend> spendList;
  int plannedBudget;
  DateTime date;
  int days;

  GroupCategory groupCategory;

  String identity;

  GroupMonth({
    required this.spendList,
    required this.plannedBudget,
    required this.date,
    required this.days,
    required this.groupCategory,
    required this.identity,
  });

  // util
  int plannedBudgetEveryday() {
    return (plannedBudget / days).toInt();
  }

  int totalSpendMoney() {
    int spendMoney = 0;
    for (Spend spend in spendList) {
      if (spend.spendType == SpendType.realSpend) {
        spendMoney += spend.spendMoney;
      }
    }
    return spendMoney;
  }
}
