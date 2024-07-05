import 'dart:async';

import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../../../UseCase/AddSpendCategoryUseCase.dart';
import '../../../../UseCase/SpendCategoryFetchUseCase.dart';

class DefaultAddSpendCategoryViewModel extends AddSpendCategoryViewModel {
  @override
  late AddSpendCategoryActions actions;
  @override
  late bool availableConfirmButton = false;
  @override
  late String spendCategoryName = "";
@override
late int maxNameLength = SpendCategory.maxNameLength;
  late AddSpendCategoryUseCase addSpendCategoryUseCase;
  late SpendCategoryFetchUseCase spendCategoryFetchUseCase;

  DefaultAddSpendCategoryViewModel(
      this.actions, this.addSpendCategoryUseCase, this.spendCategoryFetchUseCase) {}

  final _dataController =
      StreamController<AddSpendCategoryViewModel>.broadcast();
  @override
  Stream<AddSpendCategoryViewModel> get dataStream => _dataController.stream;

  @override
  void didChangeSpendCategoryName(String categoryName) {
    spendCategoryName = categoryName;
    makeAvailableSaveButtons();
    _dataController.add(this);
  }

  @override
  void didClickCancelButton() {
    actions.didClickCancel();
  }

  @override
  void didClickConfirmButton() async {
    if (await checkHasAlreadySameSpendCategory() == true) {
      actions.showAlertHasAlreadySameNameCategory();
    } else {
      await addSpendCategory();
      actions.didAddSpendCategory();
    }
  }

  Future<bool> checkHasAlreadySameSpendCategory() async {
    return await spendCategoryFetchUseCase
        .checkHasAlreadySpendCategory(spendCategoryName);
  }

  Future<void> addSpendCategory() async {
    SpendCategory newSpendCategory =
        SpendCategory(name: spendCategoryName, identity: generateUniqueId());
    return await addSpendCategoryUseCase.addSpendCategory(newSpendCategory);
  }
  @override
  void reloadData() {
    _dataController.add(this);
  }

  void makeAvailableSaveButtons() {
    if (spendCategoryName.trim().isEmpty) {
      availableConfirmButton = false;
    } else {
      availableConfirmButton = true;
    }
  }

  @override
  void dispose() {
    _dataController.close();
  }
}
