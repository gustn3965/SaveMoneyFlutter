import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/GroupMonthChart/ViewModel/GroupMonthChartViewModel.dart';

class DefaultGroupMonthChartViewModel extends GroupMonthChartViewModel {
  final _dataController =
      StreamController<GroupMonthChartViewModel>.broadcast();
  @override
  Stream<GroupMonthChartViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
