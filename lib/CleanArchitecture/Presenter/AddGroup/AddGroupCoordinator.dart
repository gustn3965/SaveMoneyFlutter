import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/DefaultAddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/Widget/AddGroupListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';

class AddGroupCoordinator extends Coordinator {
  AddGroupListViewModel? groupListviewModel;

  @override
  void pop() {
    // TODO: implement pop
    Navigator.pop(NavigationService.currentContext!);
    superCoordinator?.childCoordinator.remove(this);
  }

  @override
  void start() {
    TEST();
  }

  void startFromDate(DateTime date) {
    Widget addGroupListWidget = makeAddGroupWidget(date);
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => addGroupListWidget,
      ),
    );
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddGroupWidget(DateTime date) {
    AddGroupListViewModel groupListviewModel =
        DefaultAddGroupListViewModel(date, MockGroupCategoryFetchUseCase());
    this.groupListviewModel = groupListviewModel;

    return AddGroupListWidget(groupListviewModel);
  }

  void TEST() {
    Widget addGroupListWidget = makeAddGroupWidget(DateTime.now());
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => addGroupListWidget,
      ),
    );
  }
}
