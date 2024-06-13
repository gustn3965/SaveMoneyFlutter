import 'dart:async';

import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../../../../Extension/int+Extension.dart';
import '../../../../Domain/Entity/GroupCategory.dart';
import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../Domain/Entity/SpendCategory.dart';
import '../../../../UseCase/AddSpendUseCase.dart';
import '../../../../UseCase/GroupCategoryFetchUseCase.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import '../../../../UseCase/SpendCategoryFetchUseCase.dart';
import 'AddSpendViewModel.dart';

class DefaultAddSpendViewModel implements AddSpendViewModel {
  @override
  late AddSpendActions addSpendActions;
  @override
  late bool availableSaveButton;
  @override
  late bool availableNonSpendSaveButton = false;
  @override
  late DateTime date;
  @override
  late int spendMoney;
  @override
  late String description = "";
  @override
  late List<AddSpendViewGroupMonthItem> groupMonthList;
  @override
  AddSpendViewGroupMonthItem? selectedGroupMonth;
  @override
  late List<SpendCategory> spendCategoryList;
  @override
  SpendCategory? selectedSpendCategory;

  late SpendCategoryFetchUseCase spendFetchUseCase;
  late GroupMonthFetchUseCase groupMonthFetchUseCase;
  late AddSpendUseCase addSpendUseCase;

  DefaultAddSpendViewModel(
      this.addSpendActions,
      this.date,
      GroupMonth? groupMonth,
      this.spendFetchUseCase,
      this.groupMonthFetchUseCase,
      this.addSpendUseCase) {
    availableSaveButton = false;
    spendMoney = 0;
    groupMonthList = [];
    if (groupMonth != null) {
      selectedGroupMonth = AddSpendViewGroupMonthItem(
          groupMonth.identity, groupMonth.groupCategory.name);
    } else {
      selectedGroupMonth = null;
    }

    spendCategoryList = [];
    selectedSpendCategory = null;

    fetchSpendCategoryList();
    fetchGroupMonthList(date);
  }

  final _dataController = StreamController<AddSpendViewModel>.broadcast();

  @override
  Stream<AddSpendViewModel> get dataStream => _dataController.stream;

  @override
  void didChangeSpendMoney(int spendMoney) {
    this.spendMoney = spendMoney;
    makeAvailableSaveButtons();
    _dataController.add(this);
  }

  @override
  void didChangeDescription(String description) {
    this.description = description;
    _dataController.add(this);
  }

  @override
  Future<void> didChangeDate(DateTime date) async {
    this.date = DateTime.utc(date.year, date.month, date.day, 0, 0);

    await fetchGroupMonthList(this.date);
  }

  @override
  void didClickDateButton() {
    addSpendActions.showDatePicker(date);
    // Implement the logic for clicking date button
  }

  @override
  void didClickSaveButton() async {
    //TODO: useCase Save Logic
    Spend spend = Spend(
        date: date,
        spendMoney: spendMoney,
        groupMonthId: selectedGroupMonth!.groupMonthIdentity,
        spendCategory: selectedSpendCategory!,
        identity: generateUniqueId(),
        description: description);
    await addSpendUseCase.addSpend(spend);

    addSpendActions.didAddSpend();
  }

  @override
  void didClickNonSpendSaveButton() async {
    Spend spend = Spend(
        date: date,
        spendMoney: 0,
        groupMonthId: selectedGroupMonth!.groupMonthIdentity,
        spendCategory: null,
        identity: generateUniqueId(),
        spendType: SpendType.nonSpend);
    await addSpendUseCase.addSpend(spend);

    addSpendActions.didAddSpend();
  }

  @override
  void didClickGroupMonth(AddSpendViewGroupMonthItem groupMonth) {
    // Implement the logic for clicking group category
    selectedGroupMonth = groupMonth;
    makeAvailableSaveButtons();
    _dataController.add(this);
  }

  @override
  void didClickSpendCategory(SpendCategory spendCategory) {
    // Implement the logic for clicking spend category
    selectedSpendCategory = spendCategory;
    makeAvailableSaveButtons();
    _dataController.add(this);
  }

  @override
  Future<void> fetchSpendCategoryList() async {
    List<SpendCategory> spendCategoryList =
        await spendFetchUseCase.fetchSpendCategoryList();
    this.spendCategoryList = spendCategoryList;

    _dataController.add(this);
  }

  @override
  Future<void> fetchGroupMonthList(DateTime dateTime) async {
    List<GroupMonth> groupMonthList =
        await groupMonthFetchUseCase.fetchGroupMonthList(dateTime);
    this.groupMonthList = convertToItems(groupMonthList);

    bool hasSelectedGroupMonth = false;
    for (var groupMonth in groupMonthList) {
      if (groupMonth.identity == selectedGroupMonth?.groupMonthIdentity) {
        hasSelectedGroupMonth = true;
        break;
      }
    }

    if (hasSelectedGroupMonth == false) {
      selectedGroupMonth = null;
      makeAvailableSaveButtons();
    }

    _dataController.add(this);
  }

  List<AddSpendViewGroupMonthItem> convertToItems(
      List<GroupMonth> groupMonths) {
    return groupMonths.map((groupMonth) {
      return AddSpendViewGroupMonthItem(
          groupMonth.identity, groupMonth.groupCategory.name);
    }).toList();
  }

  @override
  void dispose() {
    _dataController.close();
  }

  void makeAvailableSaveButtons() {
    makeAvailableSaveButton();
    makeAvailableNonSpendButton();
  }

  void makeAvailableSaveButton() {
    if (spendMoney > 0 &&
        selectedSpendCategory != null &&
        selectedGroupMonth != null) {
      availableSaveButton = true;
      return;
    }

    availableSaveButton = false;
  }

  void makeAvailableNonSpendButton() {
    if (selectedGroupMonth != null) {
      availableNonSpendSaveButton = true;
      return;
    }

    availableNonSpendSaveButton = false;
  }
}
