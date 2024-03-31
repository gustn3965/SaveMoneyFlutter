import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';

import 'GroupCategory.dart';

class Spend {
  DateTime date;
  int spendMoney;

  GroupCategory groupCategory;
  SpendCategory spendCategory;

  int identity;

  Spend({
    required this.date,
    required this.spendMoney,
    required this.groupCategory,
    required this.spendCategory,
    required this.identity,
  });
}
