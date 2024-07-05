import 'dart:math';

import 'package:save_money_flutter/Extension/String+Extension.dart';

import '../Domain/Entity/GroupCategory.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';
import '../Domain/Entity/SpendCategory.dart';

import '../../Extension/DateTime+Extension.dart';

// Mock

class MockDataSet {
  void setupMockGroupMonth() {
    for (GroupMonth groupMonth in mockGroupMonthList) {
      for (int i = 0; i < 10; i++) {
        Spend spend = Spend(
            date: dateTimeAfterDay(groupMonth.date, Random().nextInt(25)),
            spendMoney: 2000 + Random().nextInt(10000),
            groupMonthId: groupMonth.identity,
            spendCategory: mockSpendCategoryList[
                Random().nextInt(mockSpendCategoryList.length)],
            identity: generateUniqueId());
        groupMonth.spendList.add(spend);
      }
    }
  }
}

List<GroupMonth> mockGroupMonthList = [
  groupNow1,
  groupNow2,
  groupNow3,
  groupBefore1,
  groupBefore2,
  groupBefore3,
  groupAfter1,
  groupAfter2,
  groupAfter3
];

List<GroupCategory> mockCategoryList = [
  mockCarCategory,
  mockPrivateCategory,
  mockDateCategory,
  mockSaveCategory
];

List<SpendCategory> mockSpendCategoryList = [
  SpendCategory(name: "커피", identity: generateUniqueId()),
  SpendCategory(name: "기름값", identity: generateUniqueId()),
  SpendCategory(name: "담배", identity: generateUniqueId()),
  SpendCategory(name: "옷", identity: generateUniqueId()),
  SpendCategory(name: "음식", identity: generateUniqueId()),
  SpendCategory(name: "자전거", identity: generateUniqueId()),
];

GroupCategory mockCarCategory =
    GroupCategory(identity: generateUniqueId(), name: "자동차 및 교통비용");
GroupCategory mockPrivateCategory =
    GroupCategory(identity: generateUniqueId(), name: "개인 비용");
GroupCategory mockDateCategory =
    GroupCategory(identity: generateUniqueId(), name: "데이트 항목");
GroupCategory mockSaveCategory =
    GroupCategory(identity: generateUniqueId(), name: "저금 항목");

GroupMonth groupNow1 = GroupMonth(
  spendList: [],
  plannedBudget: 10000,
  date: DateTime.now(),
  days: daysInDateTime(DateTime.now()),
  groupCategory: mockDateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupNow2 = GroupMonth(
  spendList: [],
  plannedBudget: 15000,
  date: DateTime.now(),
  days: daysInDateTime(DateTime.now()),
  groupCategory: mockPrivateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupNow3 = GroupMonth(
  spendList: [],
  plannedBudget: 15000,
  date: DateTime.now(),
  days: daysInDateTime(DateTime.now()),
  groupCategory: mockCarCategory,
  identity: generateUniqueId(),
);

GroupMonth groupBefore1 = GroupMonth(
  spendList: [],
  plannedBudget: 100000,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), -1, 0)),
  groupCategory: mockDateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupBefore2 = GroupMonth(
  spendList: [],
  plannedBudget: 150000,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), -1, 0)),
  groupCategory: mockPrivateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupBefore3 = GroupMonth(
  spendList: [],
  plannedBudget: 150000,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), -1, 0)),
  groupCategory: mockCarCategory,
  identity: generateUniqueId(),
);

GroupMonth groupAfter1 = GroupMonth(
  spendList: [],
  plannedBudget: 100000,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), 1, 0)),
  groupCategory: mockDateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupAfter2 = GroupMonth(
  spendList: [],
  plannedBudget: 150000,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), 1, 0)),
  groupCategory: mockPrivateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupAfter3 = GroupMonth(
  spendList: [],
  plannedBudget: 150000,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), 1, 0)),
  groupCategory: mockCarCategory,
  identity: generateUniqueId(),
);
