import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/ViewModel/DefaultGroupMonthSelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/ViewModel/GroupMonthSelectorViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSelector/Widget/GroupMonthSelectorWidget.dart';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSummary/ViewModel/GroupMonthSummaryViewModel.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Main/GroupMonthSummary/ViewModel/DefaultGroupMonthSummaryViewModel.dart';
import '../../UseCase/GroupMonthFetchUseCase.dart';
import '../AppCoordinator.dart';

import 'GroupMonthSummary/Widget/GroupMonthSummaryWidget.dart';
import 'MainHomeWidget.dart';

class MainHomeCoordinator extends Coordinator {
  @override
  void pop() {}

  GroupMonthSummaryViewModel? summaryViewModel;
  GroupMonthSelectorViewModel? selectorViewModel;

  @override
  void start() {
    Widget selectorWidget = makeSelectorWidget();
    Widget summaryWidget = makeSummaryWidget();

    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => MainHomeWidget(
          widgets: [summaryWidget, selectorWidget],
        ),
      ),
    );
  }

  Widget makeSummaryWidget() {
    summaryViewModel =
        DefaultGroupMonthSummaryViewModel(DefaultGroupMoonthFetchUseCase());
    summaryViewModel?.fetchGroupMonth(1);
    return GroupMonthSummaryWidget(viewModel: summaryViewModel!);
  }

  Widget makeSelectorWidget() {
    GroupMonthSelectorActions actions = GroupMonthSelectorActions((groupMonth) {
      summaryViewModel?.fetchGroupMonth(groupMonth.identity);
    });
    selectorViewModel = DefaultGroupMonthSelectorViewModel(
        DefaultGroupMoonthFetchUseCase(), actions);
    selectorViewModel?.fetchGroupMonthList(DateTime.now());
    return GroupMonthSelectorWidget(viewModel: selectorViewModel!);
  }

  void showAddSpendView() {}

  void updateCalendarView() {}
}
