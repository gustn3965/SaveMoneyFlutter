import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Presenter/Chart/SpendCategoryChart/ViewModel/SpendCategoryChartViewModel.dart';

class DefaultSpendCategoryChartViewModel extends SpendCategoryChartViewModel {
  final _dataController =
      StreamController<SpendCategoryChartViewModel>.broadcast();
  @override
  Stream<SpendCategoryChartViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
