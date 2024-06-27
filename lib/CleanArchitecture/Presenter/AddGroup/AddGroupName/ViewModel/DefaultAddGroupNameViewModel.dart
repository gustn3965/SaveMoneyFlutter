import 'dart:async';
import 'dart:ffi';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';

class DefaultAddGroupNameViewModel extends AddGroupNameViewModel {
  @override
  late AddGroupNameActions addGroupNameActions;
  @override
  late String groupName = "";
  @override
  late bool availableConfirmButton = false;
@override
late int maxNameLength = GroupCategory.maxNameLength;
  DateTime date;

  GroupCategoryFetchUseCase groupCategoryFetchUseCase;

  final _dataController = StreamController<AddGroupNameViewModel>.broadcast();

  DefaultAddGroupNameViewModel(
      this.date, this.groupCategoryFetchUseCase, this.addGroupNameActions)
      : super(date) {
    fetch();
  }

  @override
  void didChangeGroupName(String groupName) {
    this.groupName = groupName;
    if (groupName.isEmpty) {
      availableConfirmButton = false;
    } else {
      availableConfirmButton = true;
    }

    _dataController.add(this);
  }

  @override
  void didClickConfirmButton() async {
    GroupCategory? hasCategory =
        await groupCategoryFetchUseCase.fetchGroupCategoryByName(groupName);
    if (hasCategory != null) {
      addGroupNameActions.hasAlreadyCategoryName();
      return;
    }
    addGroupNameActions.addGroupName(date, groupName);
  }

  @override
  void didClickCancelButton() {
    addGroupNameActions.cancelAddGroupName();
  }

  @override
  void reloadData() {
    _dataController.add(this);
  }
  void fetch() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _dataController.add(this);
  }

  @override
  Stream<AddGroupNameViewModel> get dataStream => _dataController.stream;

  void dispose() {
    _dataController.close();
  }
}
