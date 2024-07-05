
import 'dart:async';
import 'dart:ffi';

class LeftMonthFloatingButtonActions {
  void Function(DateTime date) moveLeftMonth;

  LeftMonthFloatingButtonActions(this.moveLeftMonth);
}

abstract class LeftMonthFloatingButtonViewModel {

  late DateTime currentDate;
  late LeftMonthFloatingButtonActions actions;

  void didClickButton();
  void reloadData();

  // Observing
  Stream<LeftMonthFloatingButtonViewModel> get dataStream;
  void dispose();
}

class DefaultLeftMonthFloatingButtonViewModel
    extends LeftMonthFloatingButtonViewModel {
  late DateTime currentDate;
  late LeftMonthFloatingButtonActions actions;

  DefaultLeftMonthFloatingButtonViewModel(this.currentDate, this.actions);

  @override
  void didClickButton() {
    DateTime beforeDate = DateTime(currentDate.year, currentDate.month - 1);
    actions.moveLeftMonth(beforeDate);
    currentDate = beforeDate;
  }

  @override
  void reloadData() {
    _dataController.add(this);
  }

  // Observing
  final _dataController = StreamController<LeftMonthFloatingButtonViewModel>.broadcast();

  @override
  Stream<LeftMonthFloatingButtonViewModel> get dataStream => _dataController.stream;

  @override
  void dispose() {
    _dataController.close();
  }
}
