import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/GroupCategoryList/ViewModel/GroupCategoryListViewModel.dart';

import '../../../../../AppColor/AppColors.dart';

class GroupCategoryListWidget extends StatelessWidget {
  final GroupCategoryListViewModel viewModel;

  GroupCategoryListWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<GroupCategoryListViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // 사용자 정의 동작을 수행합니다.
                    viewModel.didClickNavigationPopButton();
                  }),
              backgroundColor: appColors.mainColor(),
              title:  Text(
                '소비 그룹 목록',
                style: TextStyle(
                  color: appColors.blackColor(),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              )),
            backgroundColor: appColors.whiteColor(),
          body: ListView.builder(
            itemCount: (viewModel.items.length) + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ItemCountWidget();
              } else {
                return ItemWidget(index - 1);
              }
            },
          ),
        );
      },
    );
  }

  Widget ItemCountWidget() {
    return Row(
      children: [
        SizedBox(width: 25),
        Text('(${viewModel.items.length} 개)'),
      ],
    );
  }

  Widget ItemWidget(int index) {
    GroupCategoryListItem item = viewModel.items[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin:
              const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 10),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: appColors.blackColor(),
            ),
            borderRadius: BorderRadius.circular(20),
          ), //  POINT: BoxDecoration
          child: Text(
            item.name,
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 20, top: 10),
          // padding: const EdgeInsets.all(10.0),
          child: FilledButton(
            onPressed: () {
              viewModel.clickEditGroupCategoryItem(item);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: appColors.blackColor(),
              backgroundColor: appColors.editColorGray(),
              disabledBackgroundColor: appColors.editDisableColorGray(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
            child: Text(item.editStringName),
          ),
        )
      ],
    );
  }
}
