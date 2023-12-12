import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendCategory.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendDay.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';
import 'package:save_money_flutter/Widget/Main/spend_group_widget.dart';

import '../../AppColor/AppColors.dart';
import '../../DataBase/Model/NTMonth.dart';
import '../../view_model/save_money_view_model.dart';
import '../../view_model/add_spending_view_model.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'AddSpendingSpendGroupWidget.dart'; // numberFormat

class AddSpendingWidget extends StatefulWidget {
  const AddSpendingWidget({Key? key, this.spendDay}) : super(key: key);

  final NTSpendDay? spendDay;
  @override
  _AddSpendingWidgetState createState() => _AddSpendingWidgetState();
}

class _AddSpendingWidgetState extends State<AddSpendingWidget> {
  int selectedCard = -1;

  int spendingMoney = 0;
  late TextEditingController spendingTextController =
      TextEditingController(text: '${widget.spendDay?.spend ?? 0}');
  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));

  late AddSpendingViewModel spendingViewModel =
      Provider.of<AddSpendingViewModel>(context);

  @override
  Widget build(BuildContext context) {
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
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        _showDatePicker(context);
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(spendingViewModel.selectedDate),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 200,
                    height: 80,
                    child: TextField(
                      textAlign: TextAlign.center,
                      autofocus: true,
                      controller: spendingTextController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '소비금액을 입력해주세요.',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                      onChanged: (text) {
                        text = '${_formatNumber(text.replaceAll(',', ''))}';

                        spendingTextController.text = text;
                        spendingViewModel.currentInputMoney =
                            int.parse(text.replaceAll(',', ''));
                        spendingViewModel.notifyListeners();
                      },
                    ),
                  ),
                  Column(
                    // 삭제 / 저장 버튼
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                onPressed: widget.spendDay == null
                                    ? null
                                    : () async {
                                        deleteSpend();
                                      },
                                child: Text('삭제'),
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,

                                  // backgroundColor:
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: 40), // 왼쪽에 10의 패딩 추가
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: (spendingTextController
                                                .text.isEmpty ==
                                            false &&
                                        spendingViewModel.selectedCategory !=
                                            null &&
                                        spendingViewModel.selectedNtMonth !=
                                            null)
                                    ? () async {
                                        saveSpend();
                                      }
                                    : null,
                                child: Text('저장'),
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFF2C62F0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "지출 그룹 ",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AddSpendingSpendGroupWidget(),
                  SizedBox(height: 30),
                  Text(
                    "지출 항목 ",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: spendingViewModel.spendCategorys.length + 1,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 5),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: index ==
                                    (spendingViewModel.spendCategorys?.length ??
                                        0)
                                ? Colors.red
                                : spendingViewModel.selectedCategory?.id ==
                                        spendingViewModel
                                            .spendCategorys?[index].id
                                    ? AppColors.mainHightColor
                                    : AppColors.mainColor,
                            child: TextButton(
                              onPressed: () {
                                if (index ==
                                    (spendingViewModel.spendCategorys?.length ??
                                        0)) {
                                  _showAddSpendCategory();
                                } else {
                                  spendingViewModel.selectedCategory =
                                      spendingViewModel.spendCategorys?[index];
                                  spendingViewModel.notifyListeners();
                                }
                              },
                              child: Text(
                                index ==
                                        (spendingViewModel
                                                .spendCategorys?.length ??
                                            0)
                                    ? '추가 +'
                                    : spendingViewModel
                                            .spendCategorys?[index].name ??
                                        '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )));
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: spendingViewModel.selectedDate,
            onDateTimeChanged: (DateTime newDate) async {
              spendingViewModel.selectedDate = newDate;
              await spendingViewModel.fetchNTMonths(newDate);
              await spendingViewModel
                  .updateSelectedGroup(spendingViewModel.selectedGroup);
              spendingViewModel.notifyListeners();
              // await Provider.of<AddSpendingViewModel>(context).fetchNTMonths(newDate);
            },
          ),
        );
      },
    );
  }

  void _showAddSpendCategory() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('지출항목 카테고리'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '이름을 지어주세요.',
              ),
              onChanged: (text) async {},
            ),
            actions: [
              TextButton(
                child: const Text('추가'),
                onPressed: () async {
                  if (controller.text.isEmpty) {
                  } else {
                    NTSpendCategory category = NTSpendCategory(
                        id: indexDateIdFromDateTime(DateTime.now()),
                        name: controller.text,
                        countOfSpending: 0);
                    await spendingViewModel.saveMoneyViewModel
                        .addSpendCategory(category);
                    await spendingViewModel.fetchNTSpendCategory();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  void deleteSpend() async {
    if (widget.spendDay != null) {
      await spendingViewModel.saveMoneyViewModel.deleteSpend(widget.spendDay!);
      Navigator.of(context).pop();
    }
  }

  void saveSpend() async {
    if (widget.spendDay == null) {
      int id = indexDateIdFromDateTime(DateTime.now());
      int date = indexDateIdFromDateTime(
          spendingViewModel.selectedDate ?? DateTime.now());
      int monthId = spendingViewModel.selectedNtMonth?.id ?? 0;
      int groupId = spendingViewModel.selectedNtMonth?.groupId ?? 0;
      int categoryId = spendingViewModel.selectedCategory?.id ?? 0;
      int spend = spendingViewModel.currentInputMoney;
      NTSpendDay spendDay = NTSpendDay(
          id: id,
          date: date,
          spend: spend,
          monthId: monthId,
          groupId: groupId,
          categoryId: categoryId);
      await spendingViewModel.saveMoneyViewModel.addSpend(spendDay);

      NTSpendGroup? spendGroup =
          await spendingViewModel.selectedNtMonth?.fetchSpendGroup();
      await spendingViewModel.saveMoneyViewModel
          .updateSelectedGroups(spendGroup == null ? [] : [spendGroup!]);
      await spendingViewModel.saveMoneyViewModel
          .updateSelectedDay(spendingViewModel.selectedDate ?? DateTime.now());

      Navigator.of(context).pop();
    } else {
      int id = widget.spendDay!.id;
      int date = indexDateIdFromDateTime(
          spendingViewModel.selectedDate ?? DateTime.now());
      int monthId = spendingViewModel.selectedNtMonth?.id ?? 0;
      int groupId = spendingViewModel.selectedNtMonth?.groupId ?? 0;
      int categoryId = spendingViewModel.selectedCategory?.id ?? 0;
      int spend = spendingViewModel.currentInputMoney;
      NTSpendDay spendDay = NTSpendDay(
          id: id,
          date: date,
          spend: spend,
          monthId: monthId,
          groupId: groupId,
          categoryId: categoryId);
      print('${widget.spendDay!.toMap()}');
      await spendingViewModel.saveMoneyViewModel.updateSpend(spendDay);

      NTSpendGroup? spendGroup =
          await spendingViewModel.selectedNtMonth?.fetchSpendGroup();
      await spendingViewModel.saveMoneyViewModel
          .updateSelectedGroups(spendGroup == null ? [] : [spendGroup!]);
      await spendingViewModel.saveMoneyViewModel
          .updateSelectedDay(spendingViewModel.selectedDate ?? DateTime.now());

      Navigator.of(context).pop();
    }
  }
}
