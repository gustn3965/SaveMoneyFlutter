

import 'dart:ui';

// 특정 NTMonth에 모든 지출카테고리별.
class YearNtMonthSpendModel {
  String monthGroupName;

  List<YearMonthCategorySpendModel> spendModels;

  YearNtMonthSpendModel({
    required this.monthGroupName,
    required this.spendModels,
  });
}

// 해당 달의 특정 지출카테고리 합산
class YearMonthCategorySpendModel {
  int price;
  int date;
  Color color;
  String categoryName;

  YearMonthCategorySpendModel({
    required this.price,
    required this.date,
    required this.color,
    required this.categoryName,
  });
}