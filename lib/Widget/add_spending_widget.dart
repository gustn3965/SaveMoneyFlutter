import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendDay.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../view_model/save_money_view_model.dart';

import 'package:provider/provider.dart';


class AddSpendingWidget extends StatefulWidget {
  const AddSpendingWidget({Key? key}) : super(key: key);

  @override
  _AddSpendingWidgetState createState() => _AddSpendingWidgetState();
}

class _AddSpendingWidgetState extends State<AddSpendingWidget> {
  int selectedCard = -1;
  late SaveMoneyViewModel saveMoneyViewModel;

  int spendingMoney = 0;
  final spendingTextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);
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
                    setState(() {});
                  },
                ),
              ),
              Column(
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
                                        selectedCard != -1)
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemCount: saveMoneyViewModel.spendCategorys.length,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 4),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            color: index == saveMoneyViewModel.spendCategorys.length - 1 ? Color(0xFFFF005B) : selectedCard == index
                                ? Color(0xFF2C62F0)
                                : Color(0xFFA6BDFA),
                            child: TextButton( onPressed: () {
                              if (index == saveMoneyViewModel.spendCategorys.length - 1) {
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
                                setState(() {
                                    selectedCard = index;
                                });
                              }

                              },
                              child: Text(
                                saveMoneyViewModel.spendCategorys[index].name,
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
              )
            ],
          ),
        )
    );


  }

  void saveSpend() {
    int id = indexDateIdFromDateTime(DateTime.now());
    int date = indexDateIdFromDateTime(saveMoneyViewModel.selectedDay ?? DateTime.now());
    int monthId = saveMoneyViewModel.selectedNtMonth?.id ?? 0;
    int groupId = saveMoneyViewModel.selectedNtMonth?.groupId ?? 0;
    int categoryId = saveMoneyViewModel.spendCategorys[selectedCard].id;
    int spend = int.parse(spendingTextController.text);
    NTSpendDay spendDay = NTSpendDay(id: id, date: date, spend: spend, monthId: monthId, groupId: groupId, categoryId: categoryId);
    saveMoneyViewModel.addSpend(spendDay);

    Navigator.of(context).pop();
  }
}
