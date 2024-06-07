import '../../../../Domain/Entity/GroupCategory.dart';
import '../../../../Domain/Entity/SpendCategory.dart';

class AddSpendActions {
  void Function(DateTime) showDatePicker;
  void Function() didAddSpend;

  AddSpendActions(this.showDatePicker, this.didAddSpend);
}

abstract class AddSpendViewModel {
  late AddSpendActions addSpendActions;
  late bool availableSaveButton;
  late bool availableNonSpendSaveButton;
  late DateTime date;
  late int spendMoney;
  List<GroupCategory> groupCategoryList = [];
  GroupCategory? selectedGroupCategory;
  List<SpendCategory> spendCategoryList = [];
  SpendCategory? selectedSpendCategory;

  AddSpendViewModel(this.addSpendActions, this.date);

  void didChangeSpendMoney(int spendMoney);
  void didChangeDate(DateTime date);
  void didClickDateButton();
  void didClickSaveButton();
  void didClickNonSpendSaveButton();
  void didClickGroupCategory(GroupCategory groupCategory);
  void didClickSpendCategory(SpendCategory spendCategory);

  Future<void> fetchSpendCategoryList();
  Future<void> fetchGroupCategoryList(DateTime dateTime);

  // Observing
  Stream<AddSpendViewModel> get dataStream;
  void dispose();
}
