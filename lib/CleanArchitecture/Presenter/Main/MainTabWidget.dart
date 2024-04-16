import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

import 'MainTabViewModel.dart';

class MainTabWidget extends StatelessWidget {
  final MainTabViewModel viewModel;
  late Widget bodyWidget;

  MainTabWidget(this.viewModel, this.bodyWidget);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MainTabViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: bodyWidget,
          // floatingActionButton:
          //     Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //   Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: floattingButtons),
          // ]),
          bottomNavigationBar: BottomNavigationBar(
            // currentIndex: _index,
            onTap: (value) {
              if (value == 0) {
                viewModel.didClickHomeBottomTabButton();
              } else {
                viewModel.didClickSettingBottomTabButton();
              }
              // setState(() {
              //   _index = value;
              //   print(_index);
              // });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
            ],
          ),
        );
      },
    );
  }
}
