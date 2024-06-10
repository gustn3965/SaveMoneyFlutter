import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/EditSpend/ViewModel/EditSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendListUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/EditSpendUseCase.dart';

import '../../../Domain/Entity/Spend.dart';
import '../../../UseCase/GroupCategoryFetchUseCase.dart';
import '../../../UseCase/SpendCategoryFetchUseCase.dart';

class DefaultEditSpendViewModel extends EditSpendViewModel {
  late SpendCategoryFetchUseCase spendFetchUseCase;
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;
  late SpendListUseCase daySpendListUseCase;
  late EditSpendUseCase editSpendUseCase;

  final _dataController = StreamController<EditSpendViewModel>.broadcast();
  @override
  Stream<EditSpendViewModel> get dataStream => _dataController.stream;

  DefaultEditSpendViewModel(
      this.spendFetchUseCase,
      this.groupCategoryFetchUseCase,
      this.daySpendListUseCase,
      this.editSpendUseCase,
      super.editSpendActions,
      super.spendId) {
    fetchSpend(spendId);
  }

  Future<void> fetchSpend(String spendId) async {
    Spend? spend = await daySpendListUseCase.fetchSpend(spendId);
    if (spend != null) {
      date = spend.date;
      spendMoney = spend.spendMoney;
      description = spend.description;
      spendId = spendId;

      availableSaveButton = true;
      groupCategoryList = [];
      spendCategoryList = [];
      selectedGroupCategory = spend.groupCategory;
      selectedSpendCategory = spend.spendCategory;

      _dataController.add(this);
      await fetchGroupCategoryList(date!);
      await fetchSpendCategoryList();
    }
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

  @override
  void didChangeDate(DateTime date) async {
    this.date = DateTime.utc(date.year, date.month, date.day, 0, 0);

    await fetchGroupCategoryList(date);
  }

  @override
  void didChangeSpendMoney(int spendMoney) {
    this.spendMoney = spendMoney;
    makeAvailableSaveButton();
    _dataController.add(this);
  }

  @override
  void didChangeDescription(String description) {
    this.description = description;
    _dataController.add(this);
  }

  @override
  void didClickDateButton() {
    editSpendActions.showDatePicker(date ?? DateTime.now());
  }

  @override
  void didClickSaveButton() async {
    Spend editedSpend = Spend(
        identity: spendId,
        date: date!,
        groupCategory: selectedGroupCategory!,
        spendCategory: selectedSpendCategory!,
        spendMoney: spendMoney,
        description: description);
    await editSpendUseCase.editSpend(editedSpend);

    editSpendActions.didEditSpend();
  }

  @override
  void didClickDeleteButton() async {
    await editSpendUseCase.deleteSpend(spendId);

    editSpendActions.didDeleteSpend();
    // TODO: implement didClickDeleteButton
  }

  @override
  void didClickGroupCategory(GroupCategory groupCategory) {
    selectedGroupCategory = groupCategory;
    makeAvailableSaveButton();
    _dataController.add(this);
  }

  @override
  void didClickNonSpendSaveButton() async {
    // TODO: implement didClickNonSpendSaveButton
    Spend editedSpend = Spend(
        identity: spendId,
        date: date!,
        groupCategory: selectedGroupCategory!,
        spendCategory: null,
        spendMoney: 0,
        spendType: SpendType.nonSpend);
    await editSpendUseCase.editSpend(editedSpend);

    editSpendActions.didEditSpend();
  }

  @override
  void didClickSpendCategory(SpendCategory spendCategory) {
    selectedSpendCategory = spendCategory;
    makeAvailableSaveButton();
    _dataController.add(this);
  }

  @override
  void dispose() {
    _dataController.close();
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
      makeAvailableSaveButton();
    }

    _dataController.add(this);
  }

  @override
  Future<void> fetchSpendCategoryList() async {
    List<SpendCategory> spendCategoryList =
        await spendFetchUseCase.fetchSpendCategoryList();
    this.spendCategoryList = spendCategoryList;

    _dataController.add(this);
  }
}
