import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';

import 'GroupCategory.dart';

class Spend {
  DateTime date;
  int spendMoney;

  GroupCategory groupCategory;
  SpendCategory? spendCategory;

  String identity;
  SpendType spendType;

  Spend({
    required this.date,
    required this.spendMoney,
    required this.groupCategory,
    required this.spendCategory,
    required this.identity,
    this.spendType = SpendType.realSpend,
  });
}

enum SpendType {
  realSpend, // 소비
  nonSpend // 무소비 무소비인날에 소비추가하면, 무소비 spend삭제하고, 새로추가함.
}
