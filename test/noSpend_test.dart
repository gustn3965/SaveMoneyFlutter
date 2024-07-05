import 'package:flutter_test/flutter_test.dart';
// import 'package:save_money_flutter/DataBase/Model/NTSpendCategory.dart';
// import 'package:save_money_flutter/DataBase/Model/NTSpendDay.dart';
// import 'package:save_money_flutter/DataBase/sqlite_datastore.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  int noSpendId = 1234;

  // NTSpendDay spendGroup1 = NTSpendDay(
  //     id: 1,
  //     date: 1,
  //     spend: 10000,
  //     monthId: 2,
  //     groupId: 1,
  //     categoryId: 2,
  //     spendType: SpendType.spend);
  //
  // NTSpendDay spendGroup2 = NTSpendDay(
  //     id: 2,
  //     date: 1,
  //     spend: 10000,
  //     monthId: 2,
  //     groupId: 2,
  //     categoryId: 2,
  //     spendType: SpendType.spend);
  //
  // NTSpendDay noSpend1Group1 = NTSpendDay(
  //     id: 3,
  //     date: 1,
  //     spend: 0,
  //     monthId: 2,
  //     groupId: 1,
  //     categoryId: 0,
  //     spendType: SpendType.noSpend);
  //
  // NTSpendDay noSpend2Group1 = NTSpendDay(
  //     id: 4,
  //     date: 1,
  //     spend: 0,
  //     monthId: 2,
  //     groupId: 1,
  //     categoryId: 0,
  //     spendType: SpendType.noSpend);
  //
  // NTSpendDay noSpendGroup1 = NTSpendDay(
  //     id: 5,
  //     date: 1,
  //     spend: 0,
  //     monthId: 2,
  //     groupId: 1,
  //     categoryId: 0,
  //     spendType: SpendType.noSpend);
  //
  // NTSpendDay noSpendGroup2 = NTSpendDay(
  //     id: 6,
  //     date: 1,
  //     spend: 0,
  //     monthId: 2,
  //     groupId: 2,
  //     categoryId: 0,
  //     spendType: SpendType.noSpend);
  //
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  //
  // await SqliteController().initializeAsync();
  //
  // setUp(() async {
  //   await SqliteController().deleteAll(NTSpendDay.staticClassName());
  //   await SqliteController().deleteAll(NTSpendCategory.staticClassName());
  // });
  //
  // tearDown(() async {
  //   // await SqliteController().delete(
  //   //     NTSpendCategory(id: noSpendId, name: "무소비", countOfSpending: 0));
  // });
  //
  // test("무소비로 저장했다가, 소비를 추가하면, 각각 같은 그룹이면, 무소비는 없어진다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(noSpendGroup1);
  //
  //   await SqliteController().insert(spendGroup1);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'id = ?',
  //       args: [noSpendGroup1.id]);
  //
  //   expect(list.length, equals(0));
  // });
  //
  // test("무소비로 저장했다가, 소비를 추가하면, 각각 다른 그룹이면, 무소비는 없어지지않는다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(noSpendGroup1);
  //
  //   await SqliteController().insert(spendGroup2);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'id = ?',
  //       args: [noSpendGroup1.id]);
  //
  //   expect(list.length, equals(1));
  // });
  //
  // test("소비를 추가했다가, 무소비를 등록하면, 둘다 같은 그룹이라면, 무소비는 등록안된다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(spendGroup1);
  //
  //   await SqliteController().insert(noSpendGroup1);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'id = ?',
  //       args: [noSpendGroup1.id]);
  //
  //   expect(list.length, equals(0));
  // });
  //
  // test("소비를 추가했다가, 무소비를 등록하면, 둘다 같은 다른그룹이라면, 무소비는 등록된다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(spendGroup1);
  //
  //   await SqliteController().insert(noSpendGroup1);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'id = ?',
  //       args: [noSpendGroup1.id]);
  //
  //   expect(list.length, equals(0));
  // });
  //
  // // list.first 이슈 확인 ( first 는 리스트가 빈값이면 에러나옴. )
  // test("이전에 무소비 등록이 없고, 소비만 추가하면, 소비가잘추가된다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(spendGroup1);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'id = ?',
  //       args: [spendGroup1.id]);
  //
  //   expect(list.length, equals(1));
  // });
  //
  // test("같은날에, 무소비 두번 등록했는데, 각각 소비그룹이 같다면, 한번만 insert되도록한다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(noSpend1Group1);
  //   await SqliteController().insert(noSpend2Group1);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'date = ?',
  //       args: [noSpend2Group1.date]);
  //
  //   expect(list.length, equals(1));
  // });
  //
  // test("같은날에, 무소비 두번 등록헀는데, 각각 소비그룹이 다르다면, 둘다 등록되도록한다.", () async {
  //   // sqfliteFfiInit();
  //   // databaseFactory = databaseFactoryFfi;
  //
  //   await SqliteController().insert(noSpendGroup1);
  //   await SqliteController().insert(noSpendGroup2);
  //
  //   List<NTSpendCategory> list = await SqliteController().fetch(
  //       NTSpendDay.staticClassName(),
  //       where: 'date = ?',
  //       args: [noSpendGroup1.date]);
  //
  //   expect(list.length, equals(2));
  // });
}
