import '../Domain/Entity/Spend.dart';

abstract class AddSpendUseCase {
  Future<bool> addSpend(Spend spend);
}
