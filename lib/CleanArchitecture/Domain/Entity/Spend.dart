import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';

class Spend {
  DateTime date;
  int spendMoney;

  String group;
  SpendCategory spendCategory;

  int identity;

  Spend({
    required this.date,
    required this.spendMoney,
    required this.group,
    required this.spendCategory,
    required this.identity,
  });
}
