import 'Model/NTSpendDay.dart';
import 'sqlite_datastore.dart';

extension SqliteControllerNTSpend on SqliteController {
  // noSpend_test.dart

  // (같은 그룹일때) 이전에 소비등록되어있었고, 무소비를 추가하면, 무소비는 등록안되게 무소비삭제해준다.
  deleteNoSpendIfNoSpend(NTSpendDay spendDay) async {
    if (spendDay.spendType == SpendType.noSpend) {
      List<NTSpendDay> list = await this.fetch(NTSpendDay.staticClassName(),
          where: 'date = ? AND spendType = ? AND groupId = ?',
          args: [spendDay.date, SpendType.spend.rawValue, spendDay.groupId]);
      if (list.isNotEmpty) {
        await this.delete(spendDay);
      }
    }
  }

  // (같은 그룹일때) 소비 추가할때, 이전에 무소비로 되어있는 NTSpendDay 삭제.
  deleteNoSpendIfSpend(NTSpendDay spendDay) async {
    if (spendDay.spendType == SpendType.spend) {
      List<NTSpendDay> list = await this.fetch(NTSpendDay.staticClassName(),
          where: 'date = ? AND spendType = ? AND groupId = ?',
          args: [spendDay.date, SpendType.noSpend.rawValue, spendDay.groupId]);
      if (list.isNotEmpty) {
        await this.delete(list.first);
      }
    }
  }

  // noSpend_test.dart
  // (같은 그룹일때) 무소비 두번추가하면 이전 무소비는 삭제
  deleteDuplicatedNoSpend(NTSpendDay spendDay) async {
    if (spendDay.spendType == SpendType.noSpend) {
      List<NTSpendDay> list = await this.fetch(NTSpendDay.staticClassName(),
          where: 'date = ? AND spendType = ? AND groupId = ? ',
          args: [spendDay.date, SpendType.noSpend.rawValue, spendDay.groupId]);

      if (list.length > 1) {
        await this.delete(list.last);
      }
    }
  }
}
