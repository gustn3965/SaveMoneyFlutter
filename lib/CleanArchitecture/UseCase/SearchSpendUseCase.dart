
import 'package:save_money_flutter/CleanArchitecture/Data/Repository/Repository.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';
import 'package:save_money_flutter/CleanArchitecture/UseCase/MockDataSet.dart';

import '../Domain/Entity/Spend.dart';

abstract class SearchSpendUseCase {

  Future<List<Spend>> searchSpendByCategoryNameAndDescription({required String search, required bool descDate}) ;
}

class MockSearchSpendUseCase extends SearchSpendUseCase{

  @override
  Future<List<Spend>> searchSpendByCategoryNameAndDescription({required String search, required bool descDate}) async {

    List<Spend> spendList = [];
    for (GroupMonth groupMonth in mockGroupMonthList) {
      for (Spend spend in groupMonth.spendList) {
        if (spend.description.contains(search) || (spend.spendCategory != null && spend.spendCategory!.name.contains(search)))  {
          spendList.add(spend);
        }
      }
    }
    return spendList;
  }
}


class RepoSearchSpendUseCaes extends SearchSpendUseCase {

  Repository repository;

  RepoSearchSpendUseCaes(this.repository);

  @override
  Future<List<Spend>> searchSpendByCategoryNameAndDescription({required String search, required bool descDate}) async {
return await repository.searchSpendByCategoryNameAndDescription(search: search, descDate: descDate);
  }
}