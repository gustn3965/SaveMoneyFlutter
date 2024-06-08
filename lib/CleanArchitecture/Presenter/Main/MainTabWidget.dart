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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.bottomNavigationIndex,
            onTap: (value) {
              if (value == 0) {
                viewModel.didClickHomeBottomTabButton();
              } else if (value == 1) {
                viewModel.didClickChartBottomTabButton();
              } else {
                viewModel.didClickSettingBottomTabButton();
              }
            },
            selectedItemColor: AppColors.mainHightColor,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '차트'),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: '설정'),
            ],
          ),
        );
      },
    );
  }
}

// class MainTabWidget extends StatefulWidget {
//   final MainTabViewModel viewModel;
//   late Widget bodyWidget;
//
//   MainTabWidget(this.viewModel, this.bodyWidget);
//
//   @override
//   State<StatefulWidget> createState() => MainTabState();
// }
//
// class MainTabState extends State<MainTabWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<MainTabViewModel>(
//       stream: widget.viewModel.dataStream,
//       builder: (context, snapshot) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: widget.bodyWidget,
//           // floatingActionButton:
//           //     Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//           //   Row(
//           //       mainAxisAlignment: MainAxisAlignment.end,
//           //       children: floattingButtons),
//           // ]),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _index,
//             onTap: (value) {
//               if (value == 0) {
//                 widget.viewModel.didClickHomeBottomTabButton();
//               } else {
//                 widget.viewModel.didClickSettingBottomTabButton();
//               }
//               // setState(() {
//               //   _index = value;
//               //   print(_index);
//               // });
//             },
//             selectedIconTheme: IconThemeData(),
//             showSelectedLabels: true,
//             showUnselectedLabels: false,
//             items: [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
//               BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
