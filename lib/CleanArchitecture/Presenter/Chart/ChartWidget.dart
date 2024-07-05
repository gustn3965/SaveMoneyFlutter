import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

import 'ChartViewModel.dart';

class ChartWidget extends StatelessWidget {
  final List<Widget> widgets;

  final ChartViewModel viewModel;

  const ChartWidget({Key? key, required this.viewModel, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChartViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '차트',
                style: TextStyle(
                  color: appColors.blackColor(),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              ),
              backgroundColor: appColors.mainColor(),
            ),
            backgroundColor: appColors.whiteColor(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widgets,
              ),
            ),
          );
        }
    );
  }
}
