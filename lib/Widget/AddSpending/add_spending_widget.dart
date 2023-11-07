import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendCategory.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendDay.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';
import 'package:save_money_flutter/Widget/spend_group_widget.dart';

import '../../DataBase/Model/NTMonth.dart';
import '../../view_model/save_money_view_model.dart';
import '../../view_model/add_spending_view_model.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'AddSpendingSpendGroupWidget.dart'; // numberFormat

class AddSpendingWidget extends StatefulWidget {
  const AddSpendingWidget({Key? key}) : super(key: key);

  @override
  _AddSpendingWidgetState createState() => _AddSpendingWidgetState();
}

class _AddSpendingWidgetState extends State<AddSpendingWidget> {
  int selectedCard = -1;

  int spendingMoney = 0;
  final spendingTextController = TextEditingController();

  late AddSpendingViewModel spendingViewModel = Provider.of<AddSpendingViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return TapRegion(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },

          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      _showDatePicker(context);
                    },
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(spendingViewModel.selectedDate),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        height: 0,
                      ),
                    )),
                Container(
                  width: 200,
                  height: 80,
                  child: TextField(
                    controller: spendingTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: '소비금액을 입력해주세요.',
                    ),

                    onChanged: (text) {
                      // Provider.of<AddSpendingViewModel>(context, listen: false).currentInputMoney = int.parse(text);
                      spendingTextController.text = text;
                      spendingViewModel.currentInputMoney = int.parse(text);
                      spendingViewModel.notifyListeners();
                    },

                  ),
                ),
                Column( // 삭제 / 저장 버튼
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
                              onPressed: null,
                              child: Text('삭제'),
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,

                                // backgroundColor:
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
                              onPressed:
                              (spendingTextController.text.isEmpty == false &&
                                  spendingViewModel.selectedCategory != null && spendingViewModel.selectedNtMonth != null)
                                  ? () {
                                saveSpend();
                              }
                                  : null,
                              child: Text('저장'),
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                AddSpendingSpendGroupWidget(),
                // FutureBuilder<List<NTMonth>>(
                //   ?? 이거때문인가........
                //   future: spendingViewModel.fetchNTMonths(spendingViewModel.selectedDate),
                //   builder: (context, snapshot) {
                //     // String name = snapshot.data ?? '';
                //     return AddSpendingSpendGroupWidget();
                //   },
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                        shrinkWrap: false,
                        scrollDirection: Axis.vertical,
                        itemCount: spendingViewModel.spendCategorys.length,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 4),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: spendingViewModel.selectedCategory?.id == spendingViewModel.spendCategorys?[index].id
                                ? Color(0xFF2C62F0)
                                : Color(0xFFA6BDFA),
                            child: TextButton( onPressed: () {
                              if (index == (spendingViewModel.spendCategorys?.length ?? 0) - 1) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(),
                                        insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                        actions: [
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              } else {
                                spendingViewModel.selectedCategory = spendingViewModel.spendCategorys?[index];
                                spendingViewModel.notifyListeners();
                              }

                            },
                              child: Text(
                                spendingViewModel.spendCategorys?[index].name ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),

              ],
            ),
          )
      );

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
              await spendingViewModel.updateSelectedGroup(spendingViewModel.selectedGroup);
              spendingViewModel.notifyListeners();
              // await Provider.of<AddSpendingViewModel>(context).fetchNTMonths(newDate);
            },
          ),
        );
      },
    );
  }

  void saveSpend() {
    int id = indexDateIdFromDateTime(DateTime.now());
    int date = indexDateIdFromDateTime(spendingViewModel.selectedDate ?? DateTime.now());
    int monthId = spendingViewModel.selectedNtMonth?.id ?? 0;
    int groupId = spendingViewModel.selectedNtMonth?.groupId ?? 0;
    int categoryId = spendingViewModel.selectedCategory?.id ?? 0;
    int spend = int.parse(spendingTextController.text);
    NTSpendDay spendDay = NTSpendDay(id: id, date: date, spend: spend, monthId: monthId, groupId: groupId, categoryId: categoryId);
    spendingViewModel.saveMoneyViewModel.addSpend(spendDay);

    Navigator.of(context).pop();
  }

}
