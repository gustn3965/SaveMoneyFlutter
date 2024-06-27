import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/GroupCategoryList/ViewModel/GroupCategoryListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';

import '../../../../Domain/Entity/GroupCategory.dart';

class DefaultGroupCategoryListViewModel extends GroupCategoryListViewModel {
  @override
  late GroupCategoryListAction action;
  @override
  late List<GroupCategoryListItem> items = [];

  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;

  DefaultGroupCategoryListViewModel(
      {required this.action, required this.groupCategoryFetchUseCase}) {
    fetchGroupCategoryList();
  }

  @override
  void didClickNavigationPopButton() {
    action.navigationPop();
  }

  @override
  void clickEditGroupCategoryItem(GroupCategoryListItem item) {
    // TODO: implement clickEditGroupCategoryItem
    action.showEditGroupCategoryWidget(item.categoryId);
  }

  @override
  void reloadData() async {
    fetchGroupCategoryList();
  }

  void fetchGroupCategoryList() async {
    List<GroupCategory> groupCategorys =
        await groupCategoryFetchUseCase.fetchAllGroupCategoryList();

    items = convertToItem(groupCategorys);

    _dataController.add(this);
  }

  List<GroupCategoryListItem> convertToItem(
      List<GroupCategory> groupCategorys) {
    return groupCategorys
        .map((e) => GroupCategoryListItem(e.name, e.identity, "수정하기"))
        .toList();
  }

  // Observing
  final _dataController =
      StreamController<GroupCategoryListViewModel>.broadcast();
  @override
  Stream<GroupCategoryListViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
