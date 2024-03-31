import '../../../../Domain/Entity/GroupMonth.dart';

class GroupMonthSelectorActions {
  final void Function(GroupMonth) updateSelectedGroupMonth;

  GroupMonthSelectorActions(this.updateSelectedGroupMonth);
}

abstract class GroupMonthSelectorViewModel {
  late List<GroupMonth> groupMonthList = [];
  GroupMonth? selectedGroupMonth;
  late GroupMonthSelectorActions groupMonthSelectorActions;

  void didSelectGroupMonth(GroupMonth selectedGroupMonth);
  void didSelectAddGroupMonth();

  Future<void> fetchGroupMonthList(DateTime date);

  Stream<GroupMonthSelectorViewModel> get dataStream;
  void dispose();
}
