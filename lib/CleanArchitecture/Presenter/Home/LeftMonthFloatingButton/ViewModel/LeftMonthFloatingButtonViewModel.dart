
class LeftMonthFloatingButtonActions {
  void Function(DateTime date) moveLeftMonth;

  LeftMonthFloatingButtonActions(this.moveLeftMonth);
}

abstract class LeftMonthFloatingButtonViewModel {

  late DateTime currentDate;
  late LeftMonthFloatingButtonActions actions;

  void didClickButton();
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
}
