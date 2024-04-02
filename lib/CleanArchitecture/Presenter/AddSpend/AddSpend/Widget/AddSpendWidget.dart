import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/SpendCategory.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpend/AddSpend/ViewModel/AddSpendViewModel.dart';
import 'package:intl/intl.dart';

import '../../../../../AppColor/AppColors.dart';

class AddSpendWidget extends StatelessWidget {
  final AddSpendViewModel viewModel;

  late TextEditingController spendingTextController;
  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));

  AddSpendWidget(this.viewModel, {super.key}) {
    spendingTextController =
        TextEditingController(text: '${viewModel?.spendMoney ?? 0}');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<AddSpendViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        datePickerWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        spendTextFieldWidget(),
                        saveButtonWidget(context),
                        nonSpendButtonWidget(context),
                        sectionHeaderTitle("소비 그룹"),
                        groupCategoryListWidget(),
                        sectionHeaderTitle("소비 항목"),
                        spendCategoryScrollWidget(context),
                      ],
                    ),
                  )));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget sectionHeaderTitle(String title) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          color: AppColors.whiteColor,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
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
        color: AppColors.whiteColor,
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          controller: spendingTextController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: '소비금액을 입력해주세요.',
            floatingLabelAlignment: FloatingLabelAlignment.center,
          ),
          onChanged: (text) {
            if (text == '') {
              text = "0";
            }
            text = '${_formatNumber(text.replaceAll(',', ''))}';

            spendingTextController.text = text;
            viewModel.didChangeSpendMoney(int.parse(text.replaceAll(',', '')));
          },
        ),
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
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF2C62F0),
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
          style: const TextStyle(
            color: Colors.black,
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
            foregroundColor: Colors.white,
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    );
  }

  Widget groupCategoryListWidget() {
    List<Widget> chipArray = [];
    for (var category in viewModel.groupCategoryList) {
      Widget button = Material(
        color: Colors.transparent,
        child: FilterChip(
          showCheckmark: false,
          selected:
              viewModel.selectedGroupCategory?.identity == category.identity,
          backgroundColor: Colors.white,
          selectedColor: AppColors.mainRedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text("${category.name}"),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(width: 1),
          onSelected: (bool value) async {
            viewModel.didClickGroupCategory(category);
          },
        ),
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
            padding: const EdgeInsets.all(0.0),
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
                    ? Colors.red
                    : viewModel.selectedSpendCategory?.identity ==
                            viewModel.spendCategoryList[index].identity
                        ? AppColors.mainHightColor
                        : AppColors.mainColor,
                child: TextButton(
                  onPressed: () {
                    if (index == viewModel.spendCategoryList.length) {
                      // _showAddSpendCategory();
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
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
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
