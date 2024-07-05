import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';

import 'GroupCategory.dart';

class Spend {
  DateTime date;
  int spendMoney;
  String description;

  String groupMonthId;
  SpendCategory? spendCategory;

  String identity;
  SpendType spendType;

  Spend({
    required this.date,
    required this.spendMoney,
    required this.groupMonthId,
    required this.spendCategory,
    required this.identity,
    this.spendType = SpendType.realSpend,
    this.description = "",
  });

  // util
  static int maxDescriptionLength = 50;
}

enum SpendType {
  realSpend, // 소비
  nonSpend // 무소비 무소비인날에 소비추가하면, 무소비 spend삭제하고, 새로추가함.
}
