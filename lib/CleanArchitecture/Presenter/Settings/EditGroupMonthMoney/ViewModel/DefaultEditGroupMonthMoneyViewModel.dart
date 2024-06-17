
import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupMonthFetchUseCase.dart';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../UseCase/EditGroupMonthUseCase.dart';
import 'EditGroupMonthMoneyViewModel.dart';

class DefaultEditGroupMonthMoneyViewModel extends EditGroupMonthMoneyViewModel {
  @override
  late EditGroupMonthMoneyAction actions;
  @override
  late int plannedBudget = 0;
  @override
  late int everyExpectedMoney = 0;
  @override
  late bool availableConfirmButton = false;
  @override
  late DateTime date;
@override
late String groupMonthId;

late GroupMonth? groupMonth;

  late GroupMonthFetchUseCase groupMonthFetchUseCase;
  late EditGroupMonthUseCase editGroupMonthUseCase;

  final _dataController = StreamController<EditGroupMonthMoneyViewModel>.broadcast();
  @override
  Stream<EditGroupMonthMoneyViewModel> get dataStream => _dataController.stream;

  DefaultEditGroupMonthMoneyViewModel(this.groupMonthId, this.actions,
      this.groupMonthFetchUseCase, this.editGroupMonthUseCase)
      : super(groupMonthId) {
    fetch();
  }

  @override
  void didChangePlannedBudget(int plannedBudget) {
    this.plannedBudget = plannedBudget;
    if (plannedBudget == 0) {
      availableConfirmButton = false;
    } else {
      availableConfirmButton = true;
    }

    _dataController.add(this);
  }

  @override
  void didChangeEveryExpectedMoney(int everyExpectedMoney) {
    this.everyExpectedMoney = everyExpectedMoney;

    _dataController.add(this);
  }

  @override
  void didClickConfirmButton() async {
    if (groupMonth != null) {
      groupMonth?.plannedBudget = plannedBudget;

      await editGroupMonthUseCase.updateGroupMonth(groupMonth!);

      actions.didEditGroupMonth();
    }
  }

  @override
  void didClickCancelButton() {
    actions.didCancelEdit();
  }

  void fetch() async {
    GroupMonth? groupMonth = await groupMonthFetchUseCase.fetchGroupMonthByGroupId(groupMonthId);
    if (groupMonth != null) {
      this.groupMonth = groupMonth;
      plannedBudget = groupMonth.plannedBudget;
      everyExpectedMoney = groupMonth.plannedBudgetEveryday();
      date = groupMonth.date;

      _dataController.add(this);
    }
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
