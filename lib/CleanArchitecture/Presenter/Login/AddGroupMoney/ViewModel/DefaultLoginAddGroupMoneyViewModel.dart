import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupMonthUseCase.dart';

import 'LoginAddGroupMoneyViewModel.dart';

class DefaultLoginAddGroupMoneyViewModel extends LoginAddGroupMoneyViewModel {
  @override
  late LoginAddGroupMoneyAction actions;
  @override
  late int plannedBudget = 0;
  @override
  late int everyExpectedMoney = 0;
  @override
  late bool availableConfirmButton = false;
  @override
  late DateTime date;

  late String groupName;
  AddGroupMonthUseCase addGroupMonthUseCase;
  AddGroupCategoryUseCase addGroupCategoryUseCase;

  final _dataController =
      StreamController<LoginAddGroupMoneyViewModel>.broadcast();
  @override
  Stream<LoginAddGroupMoneyViewModel> get dataStream => _dataController.stream;

  DefaultLoginAddGroupMoneyViewModel(this.date, this.groupName, this.actions,
      this.addGroupMonthUseCase, this.addGroupCategoryUseCase)
      : super(date, groupName) {
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
    GroupCategory newGroupCategory =
        await addGroupCategoryUseCase.addGroupCategory(groupName);
    await addGroupMonthUseCase.addGroupMonth(
        newGroupCategory, plannedBudget, date);

    actions.didAddNewGroup();
  }

  @override
  void didClickCancelButton() {
    actions.cancelAddGroupMoney();
  }

  @override
  void reloadData() {
    _dataController.add(this);
  }

  void fetch() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _dataController.add(this);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
