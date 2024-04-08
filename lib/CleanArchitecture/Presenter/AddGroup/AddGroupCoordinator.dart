import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/DefaultAddGroupListViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/Widget/AddGroupListWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/AddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/ViewModel/DefaultAddGroupNameViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupName/Widget/AddGroupNameWidget.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/GroupCategoryFetchUseCase.dart';

class AddGroupCoordinator extends Coordinator {
  AddGroupListViewModel? groupListviewModel;
  AddGroupNameViewModel? addGroupNameViewModel;

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
    Navigator.push(
      NavigationService.currentContext!,
      MaterialPageRoute(
        builder: (context) => makeAddGroupWidget(date),
      ),
    );
  }

  @override
  void updateCurrentWidget() {
    // TODO: implement updateCurrentWidget
  }

  Widget makeAddGroupWidget(DateTime date) {
    void addCurrentGroup(DateTime date, String groupName) {}
    ;

    void addNewGroup(DateTime date) {
      Navigator.push(
        NavigationService.currentContext!,
        MaterialPageRoute(
          builder: (context) => makeAddGroupNameWidget(date),
        ),
      );
    }

    ;

    AddGroupListActions actions = AddGroupListActions(
      addNewGroup,
      addCurrentGroup,
    );

    AddGroupListViewModel groupListviewModel = DefaultAddGroupListViewModel(
        date, MockGroupCategoryFetchUseCase(), actions);
    this.groupListviewModel = groupListviewModel;

    return AddGroupListWidget(groupListviewModel);
  }

  Widget makeAddGroupNameWidget(DateTime date) {
    void cancelAddGroupName() {
      Navigator.pop(NavigationService.currentContext!);
    }

    void addGroupName(DateTime date, String groupName) {}

    AddGroupNameActions actions = AddGroupNameActions(
      cancelAddGroupName,
      addGroupName,
    );

    addGroupNameViewModel = DefaultAddGroupNameViewModel(date, actions);

    return AddGroupNameWidget(addGroupNameViewModel!);
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
