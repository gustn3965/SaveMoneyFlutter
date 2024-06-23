
class RightMonthFloatingButtonActions {
  void Function(DateTime date) moveRightMonth;

  RightMonthFloatingButtonActions(this.moveRightMonth);
}

abstract class RightMonthFloatingButtonViewModel {

  late DateTime currentDate;
  late RightMonthFloatingButtonActions actions;

  void didClickButton();
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
}
