import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupCategory/ViewModel/EditGroupCategoryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupMonthFetchUseCase.dart';

import '../../../../Domain/Entity/GroupCategory.dart';
import '../../../../Domain/Entity/GroupMonth.dart';
import '../../../../UseCase/EditGroupCategoryUseCase.dart';
import '../../../../UseCase/GroupCategoryFetchUseCase.dart';
import 'package:intl/intl.dart';

class DefaultEditGroupCategoryViewModel extends EditGroupCategoryViewModel {
  @override
  late EditGroupCategoryActions actions;
  @override
  late bool availableEditButton = false;
  @override
  late bool availableDeleteButton = false;
  @override
  late String groupCategoryName = "";
  @override
  late List<EditGroupCategoryItem> groupListItem = [];

  final _dataController =
      StreamController<EditGroupCategoryViewModel>.broadcast();
  @override
  Stream<EditGroupCategoryViewModel> get dataStream => _dataController.stream;

  late String groupCategoryId = "";
  late GroupCategory groupCategory;
  late GroupMonthFetchUseCase groupMonthFetchUseCase;
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;
  late EditGroupCategoryUseCase editGroupCategoryUseCase;

  DefaultEditGroupCategoryViewModel(
      {required this.actions,
      required this.groupCategoryId,
      required this.groupMonthFetchUseCase,
      required this.groupCategoryFetchUseCase,
      required this.editGroupCategoryUseCase}) {
    fetchGroupCategory(groupCategoryId);
  }

  @override
  void didChangeGroupCategoryName(String categoryName) {
    groupCategoryName = categoryName;
    makeAvailableEditButton();

    _dataController.add(this);
  }

  @override
  void didClickDeleteButton() {
    actions.showAlertWarningDelete();
  }

  @override
  void didClickEditButton() {
    actions.showAlertWarningEdit();
  }

  @override
  void didClickItemEditGroupMoney(EditGroupCategoryItem item) {
actions.showEditGroupMonthMoney(item.groupMonthId);
  }

  @override
  void doDeleteSpendCategory() async {
    await editGroupCategoryUseCase.deleteGroupCategory(groupCategory);
    actions.doneDeleteGroupCategory();
  }

  @override
  void doUpdateGroupCategory() async {
    groupCategory.name = groupCategoryName;
    await editGroupCategoryUseCase.updateGroupCategory(groupCategory);
    actions.doneSaveEdit();
  }

  @override
  void dispose() {
    _dataController.close();
  }

  @override
  void reloadData() {
    fetchGroupCategory(groupCategoryId);
  }

  void fetchGroupCategory(String groupCategoryId) async {
    GroupCategory? groupCategory =
        await groupCategoryFetchUseCase.fetchGroupCategoryById(groupCategoryId);
    if (groupCategory != null) {
      this.groupCategory = groupCategory;
      this.groupCategoryName = groupCategory.name;

      await fetchGroupMonthListIn(groupCategoryId);

      availableDeleteButton = true;
      _dataController.add(this);
    }
  }

  Future<void> fetchGroupMonthListIn(String groupCategoryId) async {
    List<GroupMonth> groupMonthList = await groupMonthFetchUseCase
        .fetchGroupMonthByCategoryId(groupCategoryId);

    groupListItem = convertToItem(groupMonthList);
  }

  List<EditGroupCategoryItem> convertToItem(List<GroupMonth> groupMonthList) {
    return groupMonthList
        .map((e) => EditGroupCategoryItem(
            groupName: e.groupCategory.name,
            totalSpendMoneyString:
                "${NumberFormat("#,###").format(e.totalSpendMoney())} 원",
            date: DateFormat('yyyy.MM').format(e.date),
            plannedbudgetString:
                "목표금액: ${NumberFormat("#,###").format(e.plannedBudget)} 원",
            totalSpendMoney: e.totalSpendMoney(),
            plannedbudget: e.plannedBudget,
    editMoneyButtonString: "금액 수정",
    groupMonthId: e.identity))
        .toList();
  }

  void makeAvailableEditButton() {
    if (groupCategory.name != groupCategoryName &&
        groupCategoryName.trim().isNotEmpty) {
      availableEditButton = true;
    } else {
      availableEditButton = false;
    }
  }
}
