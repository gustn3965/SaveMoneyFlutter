import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupList/ViewModel/AddGroupListViewModel.dart';

import '../../../../../AppColor/AppColors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddGroupListWidget extends StatelessWidget {
  final AddGroupListViewModel viewModel;

  AddGroupListWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<AddGroupListViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          if (viewModel?.groupCategoryItems == null) {
            return CircularProgressIndicator();
          }
          return Scaffold(
            appBar: AppBar(
                backgroundColor: AppColors.mainColor,
                title: const Text(
                  '지출 그룹 추가',
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
              itemCount: (viewModel.groupCategoryItems.length) + 1,
              itemBuilder: (context, index) {
                if (index < viewModel.groupCategoryItems.length) {
                  return GroupCategoryListItem(index);
                } else {
                  return addGroupButton();
                }
              },
            ),
          );
        });
  }

  Widget GroupCategoryListItem(int index) {
    return Slidable(
        key: const ValueKey(0),
        closeOnScroll: true,
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.3,
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '삭제',
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                  left: 20, right: 10, top: 15, bottom: 10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(20),
              ), //  POINT: BoxDecoration
              child: Text(
                viewModel.groupCategoryItems[index].groupName,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 20, top: 10),
              // padding: const EdgeInsets.all(10.0),
              child: FilledButton(
                onPressed:
                    viewModel.groupCategoryItems[index].isAddedGroup == false
                        ? () {
                            viewModel.didClickAddCurrentItem(index);
                          }
                        : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFFA6BEFB),
                  disabledBackgroundColor: Color(0xFFD5DFF9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                child:
                    Text(viewModel.groupCategoryItems[index].addThisGroupName),
              ),
            )
          ],
        ));
  }

  Widget addGroupButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: FilledButton(
          onPressed: () {
            viewModel.didClickAddNewGroupCategoryButton();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFA6BEFB),
            disabledBackgroundColor: const Color(0xFFD5DFF9),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          child: Text(viewModel.addGroupCategoryButtonName),
        ),
      ),
    );
  }
}
