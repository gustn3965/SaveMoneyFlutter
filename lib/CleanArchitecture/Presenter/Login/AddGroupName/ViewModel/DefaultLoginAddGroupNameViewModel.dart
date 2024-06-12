import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';
import 'LoginAddGroupNameViewModel.dart';

class DefaultLoginAddGroupNameViewModel extends LoginAddGroupNameViewModel {
  @override
  late LoginAddGroupNameActions addGroupNameActions;
  @override
  late String groupName = "";
  @override
  late bool availableConfirmButton = false;

  DateTime date;

  final _dataController =
      StreamController<LoginAddGroupNameViewModel>.broadcast();

  DefaultLoginAddGroupNameViewModel(this.date, this.addGroupNameActions)
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
    addGroupNameActions.addGroupName(date, groupName);
  }

  void fetch() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _dataController.add(this);
  }

  @override
  Stream<LoginAddGroupNameViewModel> get dataStream => _dataController.stream;

  void dispose() {
    _dataController.close();
  }
}
