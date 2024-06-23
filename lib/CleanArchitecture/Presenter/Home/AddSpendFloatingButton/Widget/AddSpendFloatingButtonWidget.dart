import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

import '../ViewModel/AddSpendFloatingButtonViewModel.dart';

class AddSpendFloatingButtonWidget extends StatelessWidget {
  final AddSpendFloatingButtonViewModel viewModel;

  const AddSpendFloatingButtonWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      heroTag: 'addspend',
      onPressed: () {
        viewModel.didClickButton();
      },
      backgroundColor: AppColors.mainRedColor,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
