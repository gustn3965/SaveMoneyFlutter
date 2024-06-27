
import 'dart:async';

class RightMonthFloatingButtonActions {
  void Function(DateTime date) moveRightMonth;

  RightMonthFloatingButtonActions(this.moveRightMonth);
}

abstract class RightMonthFloatingButtonViewModel {

  late DateTime currentDate;
  late RightMonthFloatingButtonActions actions;

  void didClickButton();
  void reloadData();
  // Observing
  Stream<RightMonthFloatingButtonViewModel> get dataStream;
  void dispose();
}

class DefaultRightMonthFloatingButtonViewModel
    extends RightMonthFloatingButtonViewModel {
  late DateTime currentDate;
  late RightMonthFloatingButtonActions actions;

  DefaultRightMonthFloatingButtonViewModel(this.currentDate, this.actions);

  @override
  void didClickButton() {
    DateTime nextDate = DateTime(currentDate.year, currentDate.month + 1);
    actions.moveRightMonth(nextDate);
    currentDate = nextDate;
  }


  @override
  void reloadData() {
    _dataController.add(this);
  }

  // Observing
  final _dataController = StreamController<RightMonthFloatingButtonViewModel>.broadcast();

  @override
  Stream<RightMonthFloatingButtonViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
