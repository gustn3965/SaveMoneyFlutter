class AddSpendFloatingButtonActions {
  void Function() showAddSpend;

  AddSpendFloatingButtonActions(this.showAddSpend);
}

abstract class AddSpendFloatingButtonViewModel {
  late AddSpendFloatingButtonActions actions;

  void didClickButton();
}

class DefaultAddSpendFloatingButtonViewModel
    extends AddSpendFloatingButtonViewModel {
  late AddSpendFloatingButtonActions actions;

  DefaultAddSpendFloatingButtonViewModel(this.actions);

  @override
  void didClickButton() {
    actions.showAddSpend();
  }
}
