import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/ViewModel/AddSpendViewModel.dart';
import 'package:intl/intl.dart';

import '../../../../../AppColor/AppColors.dart';
import '../ViewModel/EditSpendViewModel.dart';

class EditSpendWidget extends StatelessWidget {
  final EditSpendViewModel viewModel;

  late TextEditingController descriptionTextController =
      TextEditingController(text: '${viewModel?.description ?? 0}');
  late TextEditingController spendingTextController =
      TextEditingController(text: '${viewModel?.spendMoney ?? 0}');
  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));

  EditSpendWidget(this.viewModel, {super.key}) {
    viewModel.dataStream.listen((event) {
      spendingTextController.text =
          NumberFormat("#,###").format(event.spendMoney);
      descriptionTextController.text = event.description ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<EditSpendViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData == null) {
          return CircularProgressIndicator();
        } else {
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
                        deleteAndSaveButtonWidget(context),
                        nonSpendButtonWidget(context),
                        sectionHeaderTitle("바인더", 30),
                        groupCategoryListWidget(),
                        sectionHeaderTitle("소비 카테고리", 10),
                        spendCategoryScrollWidget(context),
                      ],
                    ),
                  )));
        }
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
    return Material(
      child: Container(
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
            labelText: '소비금액을 입력해주세요.',
            floatingLabelAlignment: FloatingLabelAlignment.center,
          ),
          onChanged: (text) {
            final TextSelection previousCursorPos =
                spendingTextController.selection;
            if (text == '') {
              text = "0";
            } else if (int.parse(text) > 99999999999) { // 천억
              text = "99999999999";
            }
            text = '${_formatNumber(text.replaceAll(',', ''))}';

            spendingTextController.text = text;
            // spendingTextController.selection = previousCursorPos;
            viewModel.didChangeSpendMoney(int.parse(text.replaceAll(',', '')));
          },
        ),
      ),
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
            labelText: '설명을 입력해주세요 (선택)',
            floatingLabelAlignment: FloatingLabelAlignment.center,
          ),
          onChanged: (text) {
            descriptionTextController.text = text;
            viewModel.didChangeDescription(text);
          },
        ),
      ),
    );
  }

  Widget deleteAndSaveButtonWidget(context) {
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
                width: MediaQuery.of(context).size.width * 0.35,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    viewModel?.didClickDeleteButton();
                  },
                  child: Text('삭제'),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    foregroundColor: appColors.constWhiteColor(),
                    disabledForegroundColor: appColors.lightBlackColor(),
                    backgroundColor: appColors.deleteButton(),
                    disabledBackgroundColor: appColors.deleteDisableButton(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 40), // 왼쪽에 10의 패딩 추가
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    viewModel?.didClickSaveButton();
                  },
                  child: Text('수정'),
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
          ],
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
          onPressed: () async {
            viewModel?.didClickNonSpendSaveButton();
          },
          child: Text('👍무소비로 저장', style: TextStyle(color: Colors.black)),
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
    for (var category in viewModel.groupMonthList) {
      Widget button = FilterChip(
          showCheckmark: false,
          selected: viewModel.selectedGroupMonth?.groupMonthIdentity ==
              category.groupMonthIdentity,
          backgroundColor: appColors.whiteColor(),
          selectedColor: appColors.mainRedColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text("${category.groupCategoryName}",style: TextStyle(color: appColors.blackColor())),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(width: 1, color: appColors.blackColor()),
          onSelected: (bool value) async {
            viewModel.didClickGroupMonth(category);
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
                    ? appColors.confirmColor()
                    : appColors.confirmNormalColor(),
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
                      color: index == (viewModel.spendCategoryList.length)
                          ? appColors.blackColor()
                          : viewModel.selectedSpendCategory?.identity ==
                          viewModel.spendCategoryList[index].identity
                          ? appColors.constWhiteColor()
                          : appColors.constBlackColor(),
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
