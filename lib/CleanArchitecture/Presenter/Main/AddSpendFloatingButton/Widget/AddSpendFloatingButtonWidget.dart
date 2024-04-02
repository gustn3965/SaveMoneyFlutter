import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ViewModel/AddSpendFloatingButtonViewModel.dart';

class AddSpendFloatingButtonWidget extends StatelessWidget {
  final AddSpendFloatingButtonViewModel viewModel;

  const AddSpendFloatingButtonWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      onPressed: () {
        viewModel.didClickButton();
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
