import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Settings/EditSpendCategory/ViewModel/EditSpendCategoryViewModel.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../AppCoordinator.dart';
import 'package:intl/intl.dart';

class EditSpendCategoryWidget extends StatelessWidget {
  EditSpendCategoryViewModel viewModel;

  late TextEditingController spendCategoryTextController =
      TextEditingController();

  EditSpendCategoryWidget(this.viewModel, {super.key}) {
    viewModel.dataStream.listen((event) {
      spendCategoryTextController.text = event.spendCategoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditSpendCategoryViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: appColors.mainColor(),
                title: Text(
                  '소비 카테고리 수정',
                  style: TextStyle(
                    color: appColors.blackColor(),
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    height: 0,
                  ),
                )),
            body: SingleChildScrollView(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: appColors.whiteColor(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          descriptionTextFieldWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          cancelAndConfirmButtons(),
                          SizedBox(height: 40),
                          if (viewModel.spendListItem.isNotEmpty)
                            spendListHeader(),
                          spendListWidget(),
                        ],
                      ),
                    ))));
      },
    );
  }

  Widget descriptionTextFieldWidget() {
    return Material(
      child: Container(
        width: 200,
        height: 80,
        color: appColors.whiteColor(),
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          controller: spendCategoryTextController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15),
          maxLength: viewModel.maxNameLength,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appColors.mainTintColor(), width: 2.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appColors.mainColor(), width: 1.0),
            ),
            labelText: '소비 카테고리 이름',
            floatingLabelAlignment: FloatingLabelAlignment.start,
          ),
          onChanged: (text) {
            spendCategoryTextController.text = text;
            viewModel.didChangeSpendCategoryName(text);
          },
        ),
      ),
    );
  }

  Widget cancelAndConfirmButtons() {
    return Column(
      // 삭제 / 저장 버튼
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
              child: Container(
                width: MediaQuery.of(
                            NavigationService.navigatorKey.currentContext!)
                        .size
                        .width *
                    0.35,
                height: 45,
                child: ElevatedButton(
                  onPressed: (viewModel?.availableDeleteButton == true)
                      ? () async {
                          viewModel?.didClickDeleteButton();
                        }
                      : null,
                  child: Text('삭제'),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    foregroundColor: appColors.whiteColor(),
                    backgroundColor: appColors.deleteButton(),
                    disabledBackgroundColor: appColors.deleteDisableButton(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 40), // 왼쪽에 10의 패딩 추가
              child: Container(
                width: MediaQuery.of(NavigationService.currentContext!)
                        .size
                        .width *
                    0.35,
                height: 45,
                child: ElevatedButton(
                  onPressed: (viewModel?.availableEditButton == true)
                      ? () async {
                          viewModel?.didClickEditButton();
                        }
                      : null,
                  child: Text('변경'),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    foregroundColor: appColors.whiteColor(),
                    disabledForegroundColor: appColors.lightBlackColor(),
                    backgroundColor: appColors.confirmColor(),
                    disabledBackgroundColor: appColors.confirmDisableColor(),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget spendListHeader() {
    return Container(
      color: appColors.lightGrayColor(),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    "해당 소비 카테고리에 지출된 내역 (${viewModel.spendListItem.length} 개)",
                    style: TextStyle(
                      color: appColors.blackColor(),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget spendListWidget() {
    return Container(
      height: MediaQuery.of(NavigationService.currentContext!).size.height / 2,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: viewModel.spendListItem.length,
        itemBuilder: (BuildContext context, int index) {
          EditSpendCategoryItem item = viewModel.spendListItem[index];
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    // child: Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          item.groupName,
                          style: const TextStyle(
                            color: Color(0xFF0082FB),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.description.isNotEmpty)
                          Text("설명 : ${item.description}"),
                        if (item.date.isNotEmpty) Text("날짜 : ${item.date}"),
                        SizedBox(height: 10),
                        Text(
                          '${NumberFormat("#,###").format(item.spendMoney)}원',
                          style: TextStyle(
                            color: appColors.blackColor(),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                    // ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
