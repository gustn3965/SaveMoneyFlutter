import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';

import '../../../../Domain/Entity/GroupCategory.dart';
import '../../../../Domain/Entity/SpendCategory.dart';

class AddSpendActions {
  void Function(DateTime) showDatePicker;
  void Function() didAddSpend;
  void Function() clickAddSpendCategory;
  void Function(String description) needAlertEmptyContent;

  AddSpendActions(
      this.showDatePicker, this.didAddSpend, this.clickAddSpendCategory, this.needAlertEmptyContent);
}

class AddSpendViewGroupMonthItem {
  String groupMonthIdentity;
  String groupCategoryName;
  AddSpendViewGroupMonthItem(this.groupMonthIdentity, this.groupCategoryName);
}

abstract class AddSpendViewModel {
  late AddSpendActions addSpendActions;
  late bool availableSaveButton;
  late bool availableNonSpendSaveButton;
  late DateTime date;
  late int spendMoney;
  late String description;
  late int maxDescriptionLength;
  List<AddSpendViewGroupMonthItem> groupMonthList = [];
  AddSpendViewGroupMonthItem? selectedGroupMonth;
  List<SpendCategory> spendCategoryList = [];
  SpendCategory? selectedSpendCategory;

  AddSpendViewModel(
      {required this.addSpendActions,
      required this.date,
      required GroupMonth? groupMonth});

  void didChangeSpendMoney(int spendMoney);
  void didChangeDescription(String description);
  void didChangeDate(DateTime date);
  void didClickDateButton();
  void didClickSaveButton();
  void didClickNonSpendSaveButton();
  void didClickGroupMonth(AddSpendViewGroupMonthItem groupMonth);
  void didClickSpendCategory(SpendCategory spendCategory);
  void didClickAddSpendCategory();

  Future<void> fetchSpendCategoryList();
  Future<void> fetchGroupMonthList(DateTime dateTime);

  // Observing
  Stream<AddSpendViewModel> get dataStream;
  void dispose();
}
