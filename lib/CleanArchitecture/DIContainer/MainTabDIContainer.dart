import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/MainTabWidget.dart';

import '../Presenter/Home/AddSpendFloatingButton/ViewModel/AddSpendFloatingButtonViewModel.dart';
import '../Presenter/Home/AddSpendFloatingButton/Widget/AddSpendFloatingButtonWidget.dart';
import '../Presenter/Home/Calendar/ViewModel/DefaultGroupMonthCalendarViewModel.dart';
import '../Presenter/Home/Calendar/ViewModel/GroupMonthCalendarViewModel.dart';
import '../Presenter/Home/Calendar/Widget/GroupMonthCalendarWidget.dart';
import '../Presenter/Home/GroupMonthSelector/ViewModel/DefaultGroupMonthSelectorViewModel.dart';
import '../Presenter/Home/GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import '../Presenter/Home/GroupMonthSelector/Widget/GroupMonthSelectorWidget.dart';
import '../Presenter/Home/GroupMonthSummary/ViewModel/DefaultGroupMonthSummaryViewModel.dart';
import '../Presenter/Home/GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';
import '../Presenter/Home/GroupMonthSummary/Widget/GroupMonthSummaryWidget.dart';
import '../UseCase/GroupMonthFetchUseCase.dart';
import 'AppDIContainer.dart';

class MainTabDIContainer {
  AppStatus appStatus;

  MainTabDIContainer(this.appStatus);

  // Main
  MainTabViewModel makeMainHomeViewModel() {
    MainTabViewModel viewModel = DefaultMainTabViewModel();
    return viewModel;
  }

  MainTabWidget makeMainHomeWidget(
      MainTabViewModel viewModel, List<Widget> bodyWidgets) {
    return MainTabWidget(viewModel, bodyWidgets);
  }
}
