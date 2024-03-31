import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';

import '../Domain/Entity/GroupMonth.dart';
import '../Domain/Entity/Spend.dart';

abstract class GroupMonthFetchUseCase {
  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date);

  Future<GroupMonth> fetchGroupMonth(int groupId);
}

class DefaultGroupMoonthFetchUseCase extends GroupMonthFetchUseCase {
  @override
  Future<List<GroupMonth>> fetchGroupMonthList(DateTime date) async {
    // 예시 데이터 리스트 반환

    await Future.delayed(
        const Duration(milliseconds: 1000)); // 비동기 처리를 위해 await 사용

    return [group1, group2, group3];
  }

  @override
  Future<GroupMonth> fetchGroupMonth(int groupId) async {
    // 예시 데이터 반환
    await Future.delayed(
        const Duration(milliseconds: 1000)); // 비동기 처리를 위해 await 사용

    if (groupId == 1) {
      return group1;
    } else if (groupId == 2) {
      return group2;
    } else {
      return group3;
    }
  }

  GroupMonth group1 = GroupMonth(
    spendList: [
      Spend(
          date: DateTime.now(),
          spendMoney: 100,
          group: "Group",
          spendCategory: SpendCategory(name: "커피", identity: 3),
          identity: 1)
    ],
    plannedBudget: 1000,
    date: DateTime.now(),
    name: "데이트 항목",
    identity: 1,
  );

  GroupMonth group2 = GroupMonth(
    spendList: [
      Spend(
          date: DateTime.now(),
          spendMoney: 200,
          group: "개인 비용",
          spendCategory: SpendCategory(name: "담배", identity: 1),
          identity: 2)
    ],
    plannedBudget: 1500,
    date: DateTime.now(),
    name: "개인 비용",
    identity: 2,
  );

  GroupMonth group3 = GroupMonth(
    spendList: [
      Spend(
          date: DateTime.now(),
          spendMoney: 200,
          group: "자동차 및 교통비용",
          spendCategory: SpendCategory(name: "기름값", identity: 2),
          identity: 2)
    ],
    plannedBudget: 1500,
    date: DateTime.now(),
    name: "자동차 및 교통비용",
    identity: 3,
  );
}
