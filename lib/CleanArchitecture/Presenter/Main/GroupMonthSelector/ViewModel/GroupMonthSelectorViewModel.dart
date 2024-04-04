import '../../../../Domain/Entity/GroupMonth.dart';

class GroupMonthSelectorActions {
  final void Function(GroupMonth?) updateSelectedGroupMonth;
  final void Function() showAddGroup;

  GroupMonthSelectorActions(this.updateSelectedGroupMonth, this.showAddGroup);
}

abstract class GroupMonthSelectorViewModel {
  late GroupMonthSelectorActions groupMonthSelectorActions;
  late List<GroupMonth> groupMonthList = [];
  late GroupMonth? selectedGroupMonth;
  late String addGroupButtonName;

  void didSelectGroupMonth(GroupMonth selectedGroupMonth);
  void didSelectAddGroupMonth();

  Future<void> fetchGroupMonthList(DateTime date);

  // Observing
  Stream<GroupMonthSelectorViewModel> get dataStream;
  void dispose();
}
