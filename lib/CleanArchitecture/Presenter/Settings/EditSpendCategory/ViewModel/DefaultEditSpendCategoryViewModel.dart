import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditSpendCategory/ViewModel/EditSpendCategoryViewModel.dart';

import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../../../../Domain/Entity/SpendCategory.dart';
import '../../../../UseCase/EditSpendCategoryUseCase.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';
import '../../../../UseCase/SpendCategoryFetchUseCase.dart';
import '../../../../UseCase/SpendListUseCase.dart';
import 'package:intl/intl.dart';

class DefaultEditSpendCategoryViewModel extends EditSpendCategoryViewModel {
  @override
  late EditSpendCategoryActions actions;
  @override
  late bool availableEditButton = false;
  @override
  late String spendCategoryName = "";
  @override
  late List<EditSpendCategoryItem> spendListItem = [];

  late String spendCategoryId = "";
  late SpendCategory spendCategory;

  SpendCategoryFetchUseCase spendCategoryFetchUseCase;
  EditSpendCategoryUseCase editSpendCategoryUseCase;
  SpendListUseCase spendListUseCase;
  GroupMonthFetchUseCase groupMonthFetchUseCase;

  DefaultEditSpendCategoryViewModel(
      {required this.actions,
      required this.spendCategoryId,
      required this.spendCategoryFetchUseCase,
      required this.editSpendCategoryUseCase,
      required this.spendListUseCase,
      required this.groupMonthFetchUseCase}) {
    fetchSpendCategory(spendCategoryId);
  }

  final _dataController =
      StreamController<EditSpendCategoryViewModel>.broadcast();
  @override
  Stream<EditSpendCategoryViewModel> get dataStream => _dataController.stream;

  @override
  void didChangeSpendCategoryName(String categoryName) {
    spendCategoryName = categoryName;
    makeAvailableEditButton();

    _dataController.add(this);
  }

  @override
  void didClickDeleteButton() async {
    actions.showAlertWarningDelete();
  }

  @override
  void didClickEditButton() async {
    actions.showAlertWarningEdit();
  }

  @override
  void doUpdateSpendCategory() async {
    spendCategory.name = spendCategoryName;
    await editSpendCategoryUseCase.updateSpendCategory(spendCategory);
    actions.doneSaveEdit();
  }

  @override
  void doDeleteSpendCategory() async {
    await editSpendCategoryUseCase.deleteSpendCategory(spendCategory);
    actions.doneDeleteSpendCategory();
  }

  @override
  void dispose() {
    _dataController.close();
  }

  void fetchSpendCategory(String spendCategoryId) async {
    SpendCategory? spendCategory = await spendCategoryFetchUseCase
        .fetchSpendCategoryById(spendCategoryId: spendCategoryId);

    if (spendCategory != null) {
      this.spendCategory = spendCategory;
      this.spendCategoryName = spendCategory.name;

      await fetchSpendListIn(spendCategoryId);

      _dataController.add(this);
    }
  }

  Future<void> fetchSpendListIn(String spendCategoryId) async {
    List<Spend> spendList =
        await spendListUseCase.fetchSpendListBySpendCategoryId(
            spendCategoryId: spendCategoryId, descending: true);
    spendListItem = await convertToItem(spendList);
  }

  void makeAvailableEditButton() {
    if (spendCategory.name != spendCategoryName &&
        spendCategoryName.trim().isNotEmpty) {
      availableEditButton = true;
    } else {
      availableEditButton = false;
    }
  }

  Future<List<EditSpendCategoryItem>> convertToItem(
      List<Spend> spendList) async {
    List<String> uniqueGroupMonthIds =
        spendList.map((spend) => spend.groupMonthId).toSet().toList();

    Map<String, String> mapGroupName = {};
    List<GroupMonth> groupMonths = await groupMonthFetchUseCase
        .fetchGroupMonthByGroupIds(uniqueGroupMonthIds);
    for (GroupMonth groupMonth in groupMonths) {
      mapGroupName[groupMonth.identity] = groupMonth.groupCategory.name;
    }

    return spendList
        .map((e) => EditSpendCategoryItem(
            groupName: mapGroupName[e.groupMonthId]!,
            description: e.description,
            date: DateFormat('yyyy.MM.dd').format(e.date),
            spendMoney: e.spendMoney))
        .toList();
  }
}
