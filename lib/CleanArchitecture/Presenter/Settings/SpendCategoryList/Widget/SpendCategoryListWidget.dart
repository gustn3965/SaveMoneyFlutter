import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/SpendCategoryList/ViewModel/SpendCategoryListViewModel.dart';

import '../../../../../AppColor/AppColors.dart';

class SpendCategoryListWidget extends StatelessWidget {
  final SpendCategoryListViewModel viewModel;

  SpendCategoryListWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<SpendCategoryListViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: appColors.mainColor(),
              title: Text(
                '소비 카테고리 목록',
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
            itemCount: (viewModel.items.length) + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return addGroupButton();
              } else if (index == 1) {
                return ItemCountWidget();
              } else {
                return ItemWidget(index - 2);
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
    SpendCategoryListItem item = viewModel.items[index];
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
            color: appColors.whiteColor(),
            borderRadius: BorderRadius.circular(5),
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
              viewModel.clickEditSpendCategoryItem(item);
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

  Widget addGroupButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: FilledButton(
          onPressed: () {
            viewModel.clickAddSpendCategory();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: appColors.constWhiteColor(),
            backgroundColor: appColors.confirmColor(),
            disabledBackgroundColor: appColors.confirmDisableColor(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          child: Text(viewModel.addSpendCategoryString),
        ),
      ),
    );
  }
}
