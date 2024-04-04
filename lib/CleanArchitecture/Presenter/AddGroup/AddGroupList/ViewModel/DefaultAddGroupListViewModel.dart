import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';

import '../../../../UseCase/GroupCategoryFetchUseCase.dart';

class DefaultAddGroupListViewModel extends AddGroupListViewModel {
  @override
  late List<AddGroupListViewModelListItem> groupCategoryItems;
  @override
  late String addGroupCategoryButtonName = '    지출 그룹 추가하기    ';

  late DateTime date;
  late GroupCategoryFetchUseCase groupCategoryFetchUseCase;

  DefaultAddGroupListViewModel(this.date, this.groupCategoryFetchUseCase)
      : super(date) {
    fetchGroupCategoryList();
  }

  final _dataController =
      StreamController<DefaultAddGroupListViewModel>.broadcast();
  @override
  Stream<AddGroupListViewModel> get dataStream => _dataController.stream;

  @override
  void didClickAddCurrentItem(int index) {
    // TODO: implement didClickAddCurrentItem
  }

  @override
  void didClickAddNewGroupCategoryButton() {
    // TODO: implement didClickAddNewGroupCategoryButton
  }

  @override
  void dispose() {
    _dataController.close();
  }

  @override
  Future<void> fetchGroupCategoryList() async {
    List<GroupCategory> categoryList =
        await groupCategoryFetchUseCase.fetchAllGroupCategoryList();

    groupCategoryItems = convertItems(categoryList);

    _dataController.add(this);
  }

  List<AddGroupListViewModelListItem> convertItems(
      List<GroupCategory> categoryList) {
    List<AddGroupListViewModelListItem> items = [];
    for (var category in categoryList) {
      items.add(AddGroupListViewModelListItem(category.name));
    }
    return items;
  }
}
