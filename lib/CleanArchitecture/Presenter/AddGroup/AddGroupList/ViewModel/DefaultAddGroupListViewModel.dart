import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';

import '../../../../UseCase/GroupCategoryFetchUseCase.dart';
import '../../../../UseCase/GroupMonthFetchUseCase.dart';

class DefaultAddGroupListViewModel extends AddGroupListViewModel {
  @override
  late AddGroupListActions actions;
  @override
  late List<AddGroupListViewModelListItem> groupCategoryItems = [];
  @override
  late String addGroupCategoryButtonName = '    새로운 바인더 추가하기    ';

  late DateTime date;
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;
  late GroupMonthFetchUseCase groupMonthFetchUseCase;

  DefaultAddGroupListViewModel(this.date, this.groupCategoryFetchUseCase,
      this.groupMonthFetchUseCase, this.actions)
      : super(date) {
    fetchGroupCategoryList();
  }

  final _dataController = StreamController<AddGroupListViewModel>.broadcast();
  @override
  Stream<AddGroupListViewModel> get dataStream => _dataController.stream;

  @override
  void didClickAddCurrentItem(int index) {
    actions.addCurrentGroup(date, groupCategoryItems[index].groupName);
  }

  @override
  void didClickAddNewGroupCategoryButton() {
    actions.addNewGroup(date);
  }

  @override
  void didClickNavigationPopButton() {
    actions.navigationPop();
  }

  @override
  void dispose() {
    _dataController.close();
  }

  @override
  Future<void> fetchGroupCategoryList() async {
    List<GroupCategory> categoryList =
        await groupCategoryFetchUseCase.fetchAllGroupCategoryList();

    groupCategoryItems = await convertItems(categoryList);

    _dataController.add(this);
  }

  Future<List<AddGroupListViewModelListItem>> convertItems(
      List<GroupCategory> categoryList) async {
    List<AddGroupListViewModelListItem> items = [];
    for (var category in categoryList) {
      GroupMonth? groupMonth = await groupMonthFetchUseCase
          .fetchGroupMonthByCategoryIdAndDateTime(category.identity, date);
      bool hasGroupMonth = false;
      if (groupMonth != null) {
        hasGroupMonth = true;
      }

      items.add(AddGroupListViewModelListItem(category.name, hasGroupMonth));
    }
    return items;
  }
}
