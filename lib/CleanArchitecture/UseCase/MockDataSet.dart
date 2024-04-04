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

GroupMonth groupNow1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1)
  ],
  plannedBudget: 1000,
  date: DateTime.now(),
  groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
  identity: 1,
);

GroupMonth groupNow2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
  ],
  plannedBudget: 1500,
  date: DateTime.now(),
  groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
  identity: 2,
);

GroupMonth groupNow3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
  ],
  plannedBudget: 1500,
  date: DateTime.now(),
  groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
  identity: 3,
);

GroupMonth groupBefore1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 6),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 7),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1)
  ],
  plannedBudget: 1000,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
  identity: 4,
);

GroupMonth groupBefore2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 8),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 9),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
  identity: 5,
);

GroupMonth groupBefore3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 8),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 9),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 10),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
  identity: 6,
);

GroupMonth groupAfter1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 6),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 7),
        spendMoney: 100,
        groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: 1)
  ],
  plannedBudget: 1000,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  groupCategory: GroupCategory(identity: 3, name: "데이트 항목"),
  identity: 7,
);

GroupMonth groupAfter2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 8),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 9),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: 2),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  groupCategory: GroupCategory(identity: 2, name: "개인 비용"),
  identity: 8,
);

GroupMonth groupAfter3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 8),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 9),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 10),
        spendMoney: 200,
        groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: 2),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  groupCategory: GroupCategory(identity: 1, name: "자동차 및 교통비용"),
  identity: 9,
);
