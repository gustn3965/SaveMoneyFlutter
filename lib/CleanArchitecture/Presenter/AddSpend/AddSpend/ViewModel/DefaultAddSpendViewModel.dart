import 'dart:async';

import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../../../../Extension/int+Extension.dart';
import '../../../../Domain/Entity/GroupCategory.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../Domain/Entity/SpendCategory.dart';
import '../../../../UseCase/AddSpendUseCase.dart';
import '../../../../UseCase/GroupCategoryFetchUseCase.dart';
import '../../../../UseCase/SpendCategoryFetchUseCase.dart';
import 'AddSpendViewModel.dart';

class DefaultAddSpendViewModel implements AddSpendViewModel {
  @override
  late AddSpendActions addSpendActions;
  @override
  late bool availableSaveButton;
  @override
  late bool availableNonSpendSaveButton;
  @override
  late DateTime date;
  @override
  late int spendMoney;
  @override
  late List<GroupCategory> groupCategoryList;
  @override
  GroupCategory? selectedGroupCategory;
  @override
  late List<SpendCategory> spendCategoryList;
  @override
  SpendCategory? selectedSpendCategory;

  late SpendCategoryFetchUseCase spendFetchUseCase;
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;
  late AddSpendUseCase addSpendUseCase;

  DefaultAddSpendViewModel(
      this.addSpendActions,
      this.date,
      this.spendFetchUseCase,
      this.groupCategoryFetchUseCase,
      this.addSpendUseCase) {
    availableSaveButton = false;
    spendMoney = 0;
    groupCategoryList = [];
    selectedGroupCategory = null;
    spendCategoryList = [];
    selectedSpendCategory = null;

    fetchSpendCategoryList();
    fetchGroupCategoryList(date);
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
  Future<void> didChangeDate(DateTime date) async {
    this.date = DateTime.utc(date.year, date.month, date.day, 0, 0);

    await fetchGroupCategoryList(this.date);
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
        groupCategory: selectedGroupCategory!,
        spendCategory: selectedSpendCategory!,
        identity: generateUniqueId());
    await addSpendUseCase.addSpend(spend);

    addSpendActions.didAddSpend();
  }

  @override
  void didClickNonSpendSaveButton() async {
    Spend spend = Spend(
        date: date,
        spendMoney: 0,
        groupCategory: selectedGroupCategory!,
        spendCategory: null,
        identity: generateUniqueId(),
        spendType: SpendType.nonSpend);
    await addSpendUseCase.addSpend(spend);

    addSpendActions.didAddSpend();
  }

  @override
  void didClickGroupCategory(GroupCategory groupCategory) {
    // Implement the logic for clicking group category
    selectedGroupCategory = groupCategory;
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
  Future<void> fetchGroupCategoryList(DateTime dateTime) async {
    List<GroupCategory> groupCategoryList =
        await groupCategoryFetchUseCase.fetchGroupCategoryList(dateTime);
    this.groupCategoryList = groupCategoryList;

    bool hasSelectedCategory = false;
    for (var category in groupCategoryList) {
      if (category.identity == selectedGroupCategory?.identity) {
        hasSelectedCategory = true;
        break;
      }
    }

    if (hasSelectedCategory == false) {
      selectedGroupCategory = null;
      makeAvailableSaveButtons();
    }

    _dataController.add(this);
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
        selectedGroupCategory != null) {
      availableSaveButton = true;
      return;
    }

    availableSaveButton = false;
  }

  void makeAvailableNonSpendButton() {
    if (selectedGroupCategory != null) {
      availableNonSpendSaveButton = true;
      return;
    }

    availableNonSpendSaveButton = false;
  }
}
