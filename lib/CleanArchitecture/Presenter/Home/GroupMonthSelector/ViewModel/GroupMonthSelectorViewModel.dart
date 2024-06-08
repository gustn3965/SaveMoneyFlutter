import '../../../../Domain/Entity/GroupMonth.dart';

class GroupMonthSelectorActions {
  final void Function(List<String>) updateSelectedGroupIds;
  final void Function() showAddGroup;

  GroupMonthSelectorActions(this.updateSelectedGroupIds, this.showAddGroup);
}

abstract class GroupMonthSelectorViewModel {
  late GroupMonthSelectorActions groupMonthSelectorActions;
  late List<GroupMonth> groupMonthList = [];
  late List<GroupMonth> selectedGroupMonths;
  late String addGroupButtonName;

  void didSelectGroupMonth(GroupMonth selectedGroupMonth);
  void didSelectAddGroupMonth();
  void reloadFetch();

  Future<void> fetchGroupMonthList(DateTime date);

  // Observing
  Stream<GroupMonthSelectorViewModel> get dataStream;
  void dispose();
}
