import '../../../Domain/Entity/GroupCategory.dart';
import '../../../Domain/Entity/SpendCategory.dart';

class EditSpendActions {
  void Function(DateTime) showDatePicker;
  void Function() didEditSpend;
  void Function() didDeleteSpend;

  EditSpendActions(this.showDatePicker, this.didEditSpend, this.didDeleteSpend);
}

abstract class EditSpendViewModel {
  String spendId;

  late EditSpendActions editSpendActions;
  late bool availableSaveButton;
  late DateTime? date = null;
  int spendMoney = 0;
  String description = "";
  List<GroupCategory> groupCategoryList = [];
  GroupCategory? selectedGroupCategory;
  List<SpendCategory> spendCategoryList = [];
  SpendCategory? selectedSpendCategory;

  EditSpendViewModel(this.editSpendActions, this.spendId);

  void didChangeSpendMoney(int spendMoney);
  void didChangeDescription(String description);
  void didChangeDate(DateTime date);
  void didClickDateButton();
  void didClickSaveButton();
  void didClickDeleteButton();
  void didClickNonSpendSaveButton();
  void didClickGroupCategory(GroupCategory groupCategory);
  void didClickSpendCategory(SpendCategory spendCategory);

  Future<void> fetchSpendCategoryList();
  Future<void> fetchGroupCategoryList(DateTime dateTime);

  // Observing
  Stream<EditSpendViewModel> get dataStream;
  void dispose();
}
