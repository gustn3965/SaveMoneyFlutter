import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditGroupCategoryCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/GroupCategoryList/ViewModel/GroupCategoryListViewModel.dart';

import '../../../main.dart';
import '../AppCoordinator.dart';

class GroupCategoryListCoordinator extends Coordinator {
  GroupCategoryListViewModel? groupCategoryListViewModel;

  GroupCategoryListCoordinator(
      {required Coordinator superCoordinator,
      required Coordinator parentTabCoordinator})
      : super(superCoordinator, parentTabCoordinator) {
    routeName = "GroupCategoryList";
    currentWidget = makeGroupCategoryListWidget();
  }

  @override
  void updateCurrentWidget() {
    groupCategoryListViewModel?.reloadData();
  }

  Widget makeGroupCategoryListWidget() {
    void showEditSpendCategory(String groupCategoryId) {
      EditGroupCategoryCoordinator editGroupCategoryCoordinator =
          EditGroupCategoryCoordinator(
              superCoordinator: this,
              parentTabCoordinator: this,
              groupCategoryId: groupCategoryId);
      editGroupCategoryCoordinator.start();
    }

    GroupCategoryListAction action = GroupCategoryListAction(
        showEditGroupCategoryWidget: showEditSpendCategory);

    groupCategoryListViewModel =
        appDIContainer.settings.makeGroupCategoryListViewModel(action);

    return appDIContainer.settings
        .makeGroupCategoryListWidget(groupCategoryListViewModel!);
  }
}
