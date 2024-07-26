import '../../../Domain/Entity/GroupCategory.dart';
import '../../../Domain/Entity/GroupMonth.dart';
import '../../../Domain/Entity/SpendCategory.dart';

class EditSpendActions {
  void Function(DateTime) showDatePicker;
  void Function() didEditSpend;
  void Function() didDeleteSpend;
  void Function() clickAddSpendCategory;
  void Function(String description) needAlertEmptyContent;

  EditSpendActions(this.showDatePicker, this.didEditSpend, this.didDeleteSpend, this.clickAddSpendCategory, this.needAlertEmptyContent);
}

class EditSpendViewGroupMonthItem {
  String groupMonthIdentity;
  String groupCategoryName;
  EditSpendViewGroupMonthItem(this.groupMonthIdentity, this.groupCategoryName);
}

abstract class EditSpendViewModel {
  String spendId;

  late EditSpendActions editSpendActions;
  late bool availableSaveButton = true;
  late DateTime? date = null;
  late int maxDescriptionLength;
  int spendMoney = 0;
  String description = "";
  List<EditSpendViewGroupMonthItem> groupMonthList = [];
  EditSpendViewGroupMonthItem? selectedGroupMonth;
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
  void didClickGroupMonth(EditSpendViewGroupMonthItem groupMonth);
  void didClickSpendCategory(SpendCategory spendCategory);
  void didClickAddSpendCategory();
  void reloadData();

  Future<void> fetchSpendCategoryList();
  Future<void> fetchGroupMonthList(DateTime dateTime);

  // Observing
  Stream<EditSpendViewModel> get dataStream;
  void dispose();
}
