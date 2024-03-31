import '../Domain/Entity/SpendCategory.dart';

abstract class SpendCategoryFetchUseCase {
  Future<List<SpendCategory>> fetchSpendCategoryList();
}
