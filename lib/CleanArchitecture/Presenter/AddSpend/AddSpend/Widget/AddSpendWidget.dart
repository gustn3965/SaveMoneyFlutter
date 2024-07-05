import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/ViewModel/AddSpendViewModel.dart';
import 'package:intl/intl.dart';

import '../../../../../AppColor/AppColors.dart';

class AddSpendWidget extends StatelessWidget {
  final AddSpendViewModel viewModel;

  late TextEditingController descriptionTextController;
  late TextEditingController spendingTextController;

  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));

  AddSpendWidget(this.viewModel, {super.key}) {
    spendingTextController =
        TextEditingController(text: '${viewModel?.spendMoney ?? 0}');
    descriptionTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<AddSpendViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return SingleChildScrollView(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  color: appColors.whiteColor(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      datePickerWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      spendTextFieldWidget(),
                      descriptionTextFieldWidget(),
                      saveButtonWidget(context),
                      nonSpendButtonWidget(context),
                      sectionHeaderTitle("바인더", 30),
                      groupCategoryListWidget(),
                      sectionHeaderTitle("소비 카테고리", 10),
                      spendCategoryScrollWidget(context),
                    ],
                  ),
                )));
      },
    );
  }

  Widget sectionHeaderTitle(String title, double topPadding) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        Container(
          color: appColors.whiteColor(),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: appColors.blackColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget spendTextFieldWidget() {
    return Container(
        width: 200,
        height: 80,
        color: appColors.whiteColor(),
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          controller: spendingTextController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          style: TextStyle(fontSize: 20, color: appColors.blackColor()),
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appColors.mainTintColor(), width: 2.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appColors.mainColor(), width: 1.0),
            ),
            labelStyle: TextStyle(color: appColors.blackColor()),
            labelText: '소비금액을 입력해주세요.',
            floatingLabelAlignment: FloatingLabelAlignment.center,
          ),
          onChanged: (text) {
            if (text == '') {
              text = "0";
            } else if (int.parse(text) > 99999999999) {
              // 천억
              text = "99999999999";
            }

            text = '${_formatNumber(text.replaceAll(',', ''))}';

            spendingTextController.text = text;
            viewModel.didChangeSpendMoney(int.parse(text.replaceAll(',', '')));
          },
        ),
    );
  }

  Widget descriptionTextFieldWidget() {
    return Container(
        width: 200,
        height: 80,
        color: appColors.whiteColor(),
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          controller: descriptionTextController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15, color: appColors.blackColor()),
          maxLength: viewModel.maxDescriptionLength,

          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appColors.mainTintColor(), width: 2.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appColors.mainColor(), width: 1.0),
            ),
            labelStyle: TextStyle(color: appColors.blackColor()),
            labelText: '설명을 입력해주세요 (선택)',
            floatingLabelAlignment: FloatingLabelAlignment.center,
          ),
          onChanged: (text) {
            descriptionTextController.text = text;
            viewModel.didChangeDescription(text);
          },
        ),
    );
  }

  Widget saveButtonWidget(context) {
    return Column(
      // 삭제 / 저장 버튼
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: 40, right: 40), // 왼쪽에 10의 패딩 추가
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 45,
            child: ElevatedButton(
              onPressed: (viewModel?.availableSaveButton == true)
                  ? () async {
                      viewModel?.didClickSaveButton();
                    }
                  : null,
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                foregroundColor: appColors.constWhiteColor(),
                disabledForegroundColor: appColors.lightBlackColor(),
                backgroundColor: appColors.confirmColor(),
                disabledBackgroundColor: appColors.confirmDisableColor(),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget datePickerWidget() {
    return GestureDetector(
        onTap: () {
          viewModel.didClickDateButton();
        },
        child: Text(
          DateFormat('yyyy-MM-dd').format(viewModel?.date ?? DateTime.now()),
          style: TextStyle(
            color: appColors.blackColor(),
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            height: 0,
          ),
        ));
  }

  Widget nonSpendButtonWidget(context) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40), // 왼쪽에 10의 패딩 추가
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 45,
        child: ElevatedButton(
          onPressed: (viewModel?.availableNonSpendSaveButton == true)
              ? () async {
                  viewModel?.didClickNonSpendSaveButton();
                }
              : null,
          child: Text('👍무소비로 저장'),
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            foregroundColor: appColors.whiteColor(),
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    );
  }

  Widget groupCategoryListWidget() {
    List<Widget> chipArray = [];
    for (var groupMonth in viewModel.groupMonthList) {
      Widget button =  FilterChip(
          showCheckmark: false,
          selected: viewModel.selectedGroupMonth?.groupMonthIdentity ==
              groupMonth.groupMonthIdentity,
          backgroundColor: appColors.whiteColor(),
          selectedColor: appColors.mainRedColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Text("${groupMonth.groupCategoryName}", style: TextStyle(color: appColors.blackColor())),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(width: 1, color: appColors.blackColor()),
          onSelected: (bool value) async {
            viewModel.didClickGroupMonth(groupMonth);
          },
      );

      chipArray.add(button);
    }

    return Column(
      children: [
        SizedBox(height: 15),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 10.0,
          runSpacing: 10.0,
          children: chipArray,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget spendCategoryScrollWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 300,
        // color: AppColors.lightGrayColor,
        child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 70.0),
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: viewModel.spendCategoryList.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 5),
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: index == (viewModel.spendCategoryList.length)
                    ? appColors.mainRedColor()
                    : viewModel.selectedSpendCategory?.identity ==
                            viewModel.spendCategoryList[index].identity
                        ? appColors.mainTintColor()
                        : appColors.mainColor(),
                child: TextButton(
                  onPressed: () {
                    if (index == viewModel.spendCategoryList.length) {
                      viewModel.didClickAddSpendCategory();
                    } else {
                      SpendCategory selectedCategory =
                          viewModel.spendCategoryList[index];
                      viewModel.didClickSpendCategory(selectedCategory);
                    }
                  },
                  child: Text(
                    index == viewModel.spendCategoryList.length
                        ? '추가 +'
                        : viewModel.spendCategoryList[index].name,
                    style: TextStyle(
                      fontSize: 18,
                      color: appColors.blackColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
