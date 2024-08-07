import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../AppColor/AppColors.dart';
import '../ViewModel/LeftMonthFloatingButtonViewModel.dart';

class LeftMonthFloatingButtonWidget extends StatelessWidget {
  final LeftMonthFloatingButtonViewModel viewModel;

  const LeftMonthFloatingButtonWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<LeftMonthFloatingButtonViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          return FloatingActionButton(
            heroTag: 'leftmonth',
            onPressed: () {
              viewModel.didClickButton();
            },
            tooltip: 'Increment',
            backgroundColor: appColors.lightGrayColor(),
            child: const Icon(Icons.chevron_left_outlined),
          );
        }
    );

  }
}
