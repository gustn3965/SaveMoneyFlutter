import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/main.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../DIContainer/AppDIContainer.dart';
import '../ViewModel/SettingsViewModel.dart';

class SettingsWidget extends StatelessWidget {
  final SettingsViewModel viewModel;

  SettingsWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<SettingsViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.mainColor,
              title: const Text(
                '설정',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              )),
          body: ListView.builder(
            itemCount: (viewModel.list.length),
            itemBuilder: (context, index) {
              return listCell(index);
            },
          ),
        );
      },
    );
  }

  Widget listCell(int index) {
    SettingsViewModelListItem item = viewModel.list[index];
    if (index == 2) {
      return appStatusWidget(item);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            viewModel.didClickCell(index);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            margin:
                const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.name,
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget appStatusWidget(SettingsViewModelListItem item) {
    return Column(
      children: [
        Text(
          item.name,
          style: TextStyle(fontSize: 15.0),
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ListTile(
                title: const Text('DB'),
                leading: Radio<AppStatus>(
                  value: AppStatus.db,
                  groupValue: appDIContainer.appStatus,
                  onChanged: (AppStatus? value) {
                    viewModel.didChangeAppStatus(value!);
                  },
                ),
              ),
            ),
            Flexible(
              child: ListTile(
                title: const Text('Mock'),
                leading: Radio<AppStatus>(
                  value: AppStatus.mock,
                  groupValue: appDIContainer.appStatus,
                  onChanged: (AppStatus? value) {
                    viewModel.didChangeAppStatus(value!);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}