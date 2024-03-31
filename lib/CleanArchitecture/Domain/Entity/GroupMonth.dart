import 'Spend.dart';

class GroupMonth {
  List<Spend> spendList;
  int plannedBudget;
  DateTime date;
  String name;
  int identity;

  GroupMonth({
    required this.spendList,
    required this.plannedBudget,
    required this.date,
    required this.name,
    required this.identity,
  });
}
