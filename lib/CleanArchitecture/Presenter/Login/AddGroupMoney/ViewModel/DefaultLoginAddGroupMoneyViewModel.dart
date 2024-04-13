import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupCategoryUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/AddGroupMonthUseCase.dart';

import 'LoginAddGroupMoneyViewModel.dart';

class DefaultLoginAddGroupMoneyViewModel extends LoginAddGroupMoneyViewModel {
  @override
  late LoginAddGroupMoneyAction actions;
  @override
  late int plannedBudget;
  @override
  late int everyExpectedMoney;
  @override
  late bool availableConfirmButton;
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

  void fetch() async {
    await Future.delayed(const Duration(milliseconds: 100));
    availableConfirmButton = false;
    plannedBudget = 0;
    everyExpectedMoney = 0;
    _dataController.add(this);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
