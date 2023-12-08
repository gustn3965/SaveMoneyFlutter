

import 'dart:ui';

import '../../DataBase/Model/NTSpendDay.dart';
import '../../Extension/Color+Extension.dart';

class MonthSpendModel {
  final NTSpendDay spendDay;
  int price;
  int count;
  String categoryName;
  late Color color = uniqueColorFromIndex(spendDay.categoryId);

  MonthSpendModel({
    required this.spendDay,
    required this.price,
    required this.count,
    required this.categoryName,
  });
}
