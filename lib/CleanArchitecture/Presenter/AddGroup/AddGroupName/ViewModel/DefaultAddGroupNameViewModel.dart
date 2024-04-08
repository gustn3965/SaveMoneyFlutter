import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';

class DefaultAddGroupNameViewModel extends AddGroupNameViewModel {
  @override
  late AddGroupNameActions addGroupNameActions;
  @override
  late String groupName;
  @override
  late bool availableConfirmButton;

  DateTime date;

  final _dataController = StreamController<AddGroupNameViewModel>.broadcast();

  DefaultAddGroupNameViewModel(this.date, this.addGroupNameActions)
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
  void didClickConfirmButton() {
    addGroupNameActions.addGroupName(date, groupName);
  }

  @override
  void didClickCancelButton() {
    addGroupNameActions.cancelAddGroupName();
  }

  void fetch() async {
    await Future.delayed(const Duration(milliseconds: 100));
    availableConfirmButton = false;
    groupName = '';
    _dataController.add(this);
  }

  @override
  Stream<AddGroupNameViewModel> get dataStream => _dataController.stream;

  void dispose() {
    _dataController.close();
  }
}
