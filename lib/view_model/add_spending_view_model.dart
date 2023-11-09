
import 'package:flutter/cupertino.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';
import '../DataBase/Model/NTMonth.dart';
import '../DataBase/Model/NTSpendCategory.dart';
import '../DataBase/Model/NTSpendDay.dart';
import '../DataBase/sqlite_datastore.dart';
import '../Extension/DateTime+Extension.dart';


class AddSpendingViewModel extends ChangeNotifier {
    var db = SqliteController();

    List<NTMonth> ntMonths = []; // 포커싱된 내역들
    List<NTSpendGroup> ntSpendGroups = []; // ntmonth에 속하는 group들.
    List<NTSpendCategory> spendCategorys = [];

    NTMonth? selectedNtMonth ; // 메인
    NTSpendGroup? selectedGroup ;
    DateTime selectedDate = DateTime.now();
    int currentInputMoney = 0;
    NTSpendCategory? selectedCategory;

    late SaveMoneyViewModel saveMoneyViewModel;

    Future<void> setup(SaveMoneyViewModel saveMoneyViewModel) async {
        this.selectedDate = saveMoneyViewModel.selectedDay?? DateTime.now();
        this.selectedNtMonth = saveMoneyViewModel.selectedNtMonth;
        this.selectedGroup = saveMoneyViewModel.selectedGroup;
        this.saveMoneyViewModel = saveMoneyViewModel;

        await fetchNTMonths(this.selectedDate);
        await fetchNTSpendGroups();
        await fetchNTSpendCategory();

        notifyListeners();
    }

    Future<void> setupByExistSpendDay(NTSpendDay spendDay, SaveMoneyViewModel saveMoneyViewModel) async {
        this.selectedDate = dateTimeFromSince1970(spendDay.date);
        this.selectedNtMonth = await spendDay.getNtMonth();
        this.selectedGroup = await spendDay.getNTGroup();
        this.selectedCategory = await spendDay.getNTSpendCategory();
        this.currentInputMoney = spendDay.spend;

        this.saveMoneyViewModel = saveMoneyViewModel;

        await fetchNTMonths(this.selectedDate);
        await fetchNTSpendGroups();
        await fetchNTSpendCategory();

        print('????/');
        notifyListeners();
    }

    Future<void> fetchNTSpendGroups() async {
        this.ntSpendGroups = await db.fetch<NTSpendGroup>(NTSpendGroup.staticClassName());

        notifyListeners();
    }

    Future<void> fetchNTSpendCategory() async {
        print('fetch ntspendcategory........');
        this.spendCategorys = await db.fetch<NTSpendCategory>(NTSpendCategory.staticClassName());
        notifyListeners();
    }

    Future<void> fetchNTMonths(DateTime date) async {
        this.ntMonths = await db.fetch<NTMonth>(NTMonth.staticClassName(), where: 'date = ?', args: [indexMonthDateIdFromDateTime(date)]);

    }

    Future<void> updateSelectedGroup(NTSpendGroup? selectedGroup) async {

        this.selectedGroup = selectedGroup;

        for (NTMonth month in ntMonths) {
            if (month.groupId == selectedGroup?.id) {
                print(
                    'selected group: ${selectedGroup?.name}, and find selected month: ${month}');
                this.selectedNtMonth = month;
                this.selectedNtMonth?.currentLeftMoney = await month.fetchLeftMoney;
                this.selectedNtMonth?.currentNTSpendList =
                await month.existedSpendList();
                notifyListeners();
                return;
            }
        }

        this.selectedNtMonth = null;
        this.selectedGroup = null;

        print('selected group: ${selectedGroup?.name}, and not found selected month');
        notifyListeners();
    }
}