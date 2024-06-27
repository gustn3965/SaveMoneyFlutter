import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

import '../ViewModel/RightMonthFloatingButtonViewModel.dart';

class RightMonthFloatingButtonWidget extends StatelessWidget {
  final RightMonthFloatingButtonViewModel viewModel;

  const RightMonthFloatingButtonWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        heroTag: 'rightmonth',
        onPressed: () {
          viewModel.didClickButton();
        },
        backgroundColor: appColors.lightGrayColor(),
        tooltip: 'Increment',
        child: const Icon(Icons.chevron_right_outlined),
      ),
    );
  }
}
