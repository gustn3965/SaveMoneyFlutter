import 'dart:math';

import 'package:save_money_flutter/Extension/String+Extension.dart';

import '../Domain/Entity/GroupCategory.dart';
import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';
import '../Domain/Entity/SpendCategory.dart';

import '../../Extension/DateTime+Extension.dart';

// Mock

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
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId())
  ],
  plannedBudget: 100000,
  date: DateTime.now(),
  days: daysInDateTime(DateTime.now()),
  groupCategory: mockDateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupNow2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
  ],
  plannedBudget: 1500,
  date: DateTime.now(),
  days: daysInDateTime(DateTime.now()),
  groupCategory: mockPrivateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupNow3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
  ],
  plannedBudget: 1500,
  date: DateTime.now(),
  days: daysInDateTime(DateTime.now()),
  groupCategory: mockCarCategory,
  identity: generateUniqueId(),
);

GroupMonth groupBefore1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 6),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 7),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId())
  ],
  plannedBudget: 1000,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), -1, 0)),
  groupCategory: mockDateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupBefore2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 8),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 9),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), -1, 0)),
  groupCategory: mockPrivateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupBefore3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 8),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 9),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 10),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), -1, 0)),
  groupCategory: mockCarCategory,
  identity: generateUniqueId(),
);

GroupMonth groupAfter1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 6),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 7),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId())
  ],
  plannedBudget: 1000,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), 1, 0)),
  groupCategory: mockDateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupAfter2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 8),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 9),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), 1, 0)),
  groupCategory: mockPrivateCategory,
  identity: generateUniqueId(),
);

GroupMonth groupAfter3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 8),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 9),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 10),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: mockSpendCategoryList[
            Random().nextInt(mockSpendCategoryList.length)],
        identity: generateUniqueId()),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  days: daysInDateTime(dateTimeAfterMonthDay(DateTime.now(), 1, 0)),
  groupCategory: mockCarCategory,
  identity: generateUniqueId(),
);
