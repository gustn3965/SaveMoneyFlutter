import '../Domain/Entity/SpendCategory.dart';

abstract class SpendCategoryFetchUseCase {
  Future<List<SpendCategory>> fetchSpendCategoryList();
}

class MockSpendCategoryFetchUseCase extends SpendCategoryFetchUseCase {
  @override
  Future<List<SpendCategory>> fetchSpendCategoryList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return [
      SpendCategory(name: "담배", identity: 1),
      SpendCategory(name: "술", identity: 2),
      SpendCategory(name: "커피", identity: 3),
      SpendCategory(name: "카페", identity: 4),
      SpendCategory(name: "음식", identity: 5),
      SpendCategory(name: "음식", identity: 6),
    ];
  }
}
