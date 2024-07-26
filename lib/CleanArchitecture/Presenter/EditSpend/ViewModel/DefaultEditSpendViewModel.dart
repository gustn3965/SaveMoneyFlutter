import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/EditSpend/ViewModel/EditSpendViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/SpendListUseCase.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/EditSpendUseCase.dart';

import '../../../Domain/Entity/GroupMonth.dart';
import '../../../Domain/Entity/Spend.dart';
import '../../../UseCase/GroupCategoryFetchUseCase.dart';
import '../../../UseCase/GroupMonthFetchUseCase.dart';
import '../../../UseCase/SpendCategoryFetchUseCase.dart';

class DefaultEditSpendViewModel extends EditSpendViewModel {
  late int maxDescriptionLength = Spend.maxDescriptionLength;
  late SpendCategoryFetchUseCase spendFetchUseCase;
  late GroupMonthFetchUseCase groupMonthFetchUseCase;
  late SpendListUseCase daySpendListUseCase;
  late EditSpendUseCase editSpendUseCase;

  final _dataController = StreamController<EditSpendViewModel>.broadcast();
  @override
  Stream<EditSpendViewModel> get dataStream => _dataController.stream;

  DefaultEditSpendViewModel(
      this.spendFetchUseCase,
      this.groupMonthFetchUseCase,
      this.daySpendListUseCase,
      this.editSpendUseCase,
      super.editSpendActions,
      super.spendId) {
    availableSaveButton = false;
    fetchSpend(spendId);
  }

  Future<void> fetchSpend(String spendId) async {
    Spend? spend = await daySpendListUseCase.fetchSpend(spendId);

    if (spend != null) {
      GroupMonth? groupMonth = await groupMonthFetchUseCase
          .fetchGroupMonthByGroupId(spend!.groupMonthId);
      date = spend.date;
      spendMoney = spend.spendMoney;
      description = spend.description;
      spendId = spendId;

      availableSaveButton = true;
      groupMonthList = [];
      spendCategoryList = [];
      selectedGroupMonth = EditSpendViewGroupMonthItem(
          spend.groupMonthId, groupMonth?.groupCategory.name ?? "");
      selectedSpendCategory = spend.spendCategory;

      _dataController.add(this);
      await fetchGroupMonthList(date!);
      await fetchSpendCategoryList();
    }
  }

  bool canSave() {
    if (spendMoney <= 0) {
      editSpendActions.needAlertEmptyContent("금액을 입력해주세요.");
      return false;
    } else if (spendCategoryList.isEmpty) {
      editSpendActions.needAlertEmptyContent("하단에 소비 카테고리에서\n추가+ 버튼을 눌러서 추가해주세요.");
      return false;
    } else if (selectedSpendCategory == null) {
      editSpendActions.needAlertEmptyContent("하단에 소비 카테고리에서\n선택해주세요.");
      return false;
    } else if (selectedGroupMonth == null) {
      editSpendActions.needAlertEmptyContent("하단에 바인더에서\n선택해주세요.");
      return false;
    }

    return true;
  }

  bool canNonSave() {
    if (selectedGroupMonth == null) {
      editSpendActions.needAlertEmptyContent("하단에 바인더에서\n선택해주세요.");
      return false;
    }

    return true;
  }

  @override
  void didChangeDate(DateTime date) async {
    this.date = DateTime.utc(date.year, date.month, date.day, 0, 0);

    await fetchGroupMonthList(date);
  }

  @override
  void didChangeSpendMoney(int spendMoney) {
    this.spendMoney = spendMoney;
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
    if (canSave() == false) {
      return;
    }

    Spend editedSpend = Spend(
        identity: spendId,
        date: date!,
        groupMonthId: selectedGroupMonth!.groupMonthIdentity,
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
  void didClickGroupMonth(EditSpendViewGroupMonthItem groupMonth) {
    selectedGroupMonth = groupMonth;
    _dataController.add(this);
  }

  @override
  void didClickNonSpendSaveButton() async {

    if (canNonSave() == false) {
      return;
    }
    // TODO: implement didClickNonSpendSaveButton
    Spend editedSpend = Spend(
        identity: spendId,
        date: date!,
        groupMonthId: selectedGroupMonth!.groupMonthIdentity,
        spendCategory: null,
        spendMoney: 0,
        spendType: SpendType.nonSpend);
    await editSpendUseCase.editSpend(editedSpend);

    editSpendActions.didEditSpend();
  }

  @override
  void didClickSpendCategory(SpendCategory spendCategory) {
    selectedSpendCategory = spendCategory;
    _dataController.add(this);
  }

  @override
  void didClickAddSpendCategory() {
    editSpendActions.clickAddSpendCategory();
  }

  @override
  void dispose() {
    _dataController.close();
  }

  @override
  Future<void> fetchGroupMonthList(DateTime dateTime) async {
    List<GroupMonth> groupMonthList =
        await groupMonthFetchUseCase.fetchGroupMonthList(dateTime);
    this.groupMonthList = convertToItems(groupMonthList);

    bool hasSelectedCategory = false;
    for (var groupMonth in groupMonthList) {
      if (groupMonth.identity == selectedGroupMonth?.groupMonthIdentity) {
        hasSelectedCategory = true;
        break;
      }
    }

    if (hasSelectedCategory == false) {
      selectedGroupMonth = null;
    }

    _dataController.add(this);
  }

  @override
  void reloadData() {
    _dataController.add(this);
  }

  List<EditSpendViewGroupMonthItem> convertToItems(
      List<GroupMonth> groupMonths) {
    return groupMonths.map((groupMonth) {
      return EditSpendViewGroupMonthItem(
          groupMonth.identity, groupMonth.groupCategory.name);
    }).toList();
  }

  @override
  Future<void> fetchSpendCategoryList() async {
    List<SpendCategory> spendCategoryList =
        await spendFetchUseCase.fetchSpendCategoryList();
    this.spendCategoryList = spendCategoryList;

    _dataController.add(this);
  }
}
