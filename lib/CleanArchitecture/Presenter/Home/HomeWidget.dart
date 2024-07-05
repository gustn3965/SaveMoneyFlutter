import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

import 'HomeViewModel.dart';

class HomeWidget extends StatelessWidget {
  final List<Widget> widgets;
  final List<Widget> floattingButtons;

  final HomeViewModel viewModel;
  const HomeWidget(
      {Key? key, required this.viewModel, required this.widgets, required this.floattingButtons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: appColors.mainColor(),
              title: GestureDetector(
                  onTap: () {
                    // _showDatePicker();
                  },
                  child: Text(
                    // DateFormat('yyyy-MM').format(selectDateViewModel.focusedDay),
                    "홈",
                    style: TextStyle(
                      color: appColors.blackColor(),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      height: 0,
                    ),
                  )),
            ),
            backgroundColor: appColors.whiteColor(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widgets,
              ),
            ),
            floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: floattingButtons),
            ]),
          );
        });

  }
}
