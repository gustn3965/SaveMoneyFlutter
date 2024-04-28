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
GroupCategory mockCarCategory = GroupCategory(
    identity: indexDateIdFromDateTime(DateTime.now()), name: "자동차 및 교통비용");
GroupCategory mockPrivateCategory = GroupCategory(
    identity: indexDateIdFromDateTime(DateTime.now()), name: "개인 비용");
GroupCategory mockDateCategory = GroupCategory(
    identity: indexDateIdFromDateTime(DateTime.now()), name: "데이트 항목");
GroupCategory mockSaveCategory = GroupCategory(
    identity: indexDateIdFromDateTime(DateTime.now()), name: "저금 항목");

GroupMonth groupNow1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now()))
  ],
  plannedBudget: 1000,
  date: DateTime.now(),
  groupCategory: mockDateCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupNow2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
  ],
  plannedBudget: 1500,
  date: DateTime.now(),
  groupCategory: mockPrivateCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupNow3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 0),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 1),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterDay(DateTime.now(), 2),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
  ],
  plannedBudget: 1500,
  date: DateTime.now(),
  groupCategory: mockCarCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupBefore1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 6),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 7),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now()))
  ],
  plannedBudget: 1000,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  groupCategory: mockDateCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupBefore2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 8),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 9),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  groupCategory: mockPrivateCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupBefore3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 5),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 8),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 9),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), -1, 10),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), -1, 0),
  groupCategory: mockCarCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupAfter1 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 6),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 7),
        spendMoney: 100,
        groupCategory: mockDateCategory,
        spendCategory: SpendCategory(name: "커피", identity: 3),
        identity: indexDateIdFromDateTime(DateTime.now()))
  ],
  plannedBudget: 1000,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  groupCategory: mockDateCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupAfter2 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 8),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 9),
        spendMoney: 200,
        groupCategory: mockPrivateCategory,
        spendCategory: SpendCategory(name: "담배", identity: 1),
        identity: indexDateIdFromDateTime(DateTime.now())),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  groupCategory: mockPrivateCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);

GroupMonth groupAfter3 = GroupMonth(
  spendList: [
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 5),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 8),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 9),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
    Spend(
        date: dateTimeAfterMonthDay(DateTime.now(), 1, 10),
        spendMoney: 200,
        groupCategory: mockCarCategory,
        spendCategory: SpendCategory(name: "기름값", identity: 2),
        identity: indexDateIdFromDateTime(DateTime.now())),
  ],
  plannedBudget: 1500,
  date: dateTimeAfterMonthDay(DateTime.now(), 1, 0),
  groupCategory: mockCarCategory,
  identity: indexDateIdFromDateTime(DateTime.now()),
);
