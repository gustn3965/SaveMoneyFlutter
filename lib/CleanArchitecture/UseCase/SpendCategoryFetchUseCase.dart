import '../Domain/Entity/SpendCategory.dart';
import 'MockDataSet.dart';

abstract class SpendCategoryFetchUseCase {
  Future<List<SpendCategory>> fetchSpendCategoryList();
}

class MockSpendCategoryFetchUseCase extends SpendCategoryFetchUseCase {
  @override
  Future<List<SpendCategory>> fetchSpendCategoryList() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return mockSpendCategoryList;
  }
}
