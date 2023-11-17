

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:save_money_flutter/DataBase/Model/NTMonth.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';
import 'package:provider/provider.dart';

class EditSpendGroupMoneyWidget extends StatefulWidget {
  const EditSpendGroupMoneyWidget({Key? key, required this.currentMonth, required this.currentSpendGroup}) : super(key:key);

  final NTMonth currentMonth;
  final NTSpendGroup currentSpendGroup;

  @override
  State<EditSpendGroupMoneyWidget> createState() => _EditSpendGroupMoneyWidgetState();
}

class _EditSpendGroupMoneyWidgetState extends State<EditSpendGroupMoneyWidget> {

  late SaveMoneyViewModel saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context, listen: false);
  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));
  late final groupMoneyTitleController = TextEditingController(text: NumberFormat("#,###").format(widget.currentMonth.expectedSpend));

  late int everyExpectedMoney = widget.currentMonth.everyExpectedSpend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },

              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        width: 200,
                        height: 80,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: groupMoneyTitleController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            // isCollapsed: true,
                            border: UnderlineInputBorder(),
                            labelText: '금액을 입력해주세요.',
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                          ),

                          onChanged: (text) {
                            // Provider.of<AddSpendingViewModel>(context, listen: false).currentInputMoney = int.parse(text);
                            text = '${_formatNumber(text.replaceAll(',', ''))}';
                            setState(() {
                              groupMoneyTitleController.text = text;
                              int expectedMoney = int.parse(text.replaceAll(',', ''));
                              everyExpectedMoney = (expectedMoney / daysInMonthFromSince1970(widget.currentMonth.date)).toInt();


                            });

                          },
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "한달에 소비예정 금액을 정해주세요.",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height:20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          cancelButton(),
                          saveButton(),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        "소비를 아껴서 매일",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                          "${NumberFormat("#,###")
                              .format(everyExpectedMoney)}",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.deepOrangeAccent
                          ),
                          textAlign: TextAlign.center,
                        ),
                          SizedBox(width: 5),
                          Text(
                            "원을 모아봐요.💪🏻",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      SizedBox(height: 90),
                      ntmonthsListWidget(),
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
  
  Widget ntmonthsListWidget() {

    return FutureBuilder<List<NTMonth>>(
      future: widget.currentSpendGroup.ntMonths(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 동안 오류가 발생했습니다.'));
        } else {
          // 데이터를 성공적으로 가져온 경우의 화면
          final List<NTMonth>? months =  snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: months?.length == 0 ? 0 : months!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text(
                  "이전 내역",
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        months?[index-1].dateStringYYMM() ?? '',
                        style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),

                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            groupMoneyTitleController.text = NumberFormat("#,###").format(months?[index-1].expectedSpend ?? 0);
                          });
                        },
                        child: Text(
                          NumberFormat("#,###원").format(months?[index-1].expectedSpend ?? 0),
                          style: TextStyle(fontSize: 17.0, color: Colors.black38),
                        ),
                      )
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
  

  Widget saveButton() {
    return FilledButton(
      onPressed: groupMoneyTitleController.text.isEmpty ? null : () async {
        // print(widget.group.name);
        // print(groupMoneyTitleController.text);
        // print(saveMoneyViewModel.spendCategorys);
        //
        // int date = indexMonthDateIdFromDateTime(widget.selectedDate);
        int expectedMoney = int.parse(groupMoneyTitleController.text.replaceAll(',', ''));
        // int everyExpectedMoney = (expectedMoney / daysInMonthFromSince1970(date)).toInt();
        // NTMonth newMonth = NTMonth(id: widget.month.id, date: date, groupId: widget.group.id, spendType: 0, expectedSpend: expectedMoney, everyExpectedSpend: everyExpectedMoney, additionalMoney: 0);
        widget.currentMonth.expectedSpend = expectedMoney;
        widget.currentMonth.everyExpectedSpend = everyExpectedMoney;
        // await saveMoneyViewModel.addSpendGroup(widget.group);
        await saveMoneyViewModel.updateNtMonth(widget.currentMonth);

        Navigator.popUntil(context, (route) => route.isFirst);
      },
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
      child: Text('    확인    '),
    );
  }

  Widget cancelButton() {
    return FilledButton(
      onPressed: () async {
        Navigator.pop(context);
        // Navigator.popUntil(context, (route) => route.isFirst);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF575759),
        disabledBackgroundColor: Color(0xFF575759),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      child: Text('    취소    '),
    );
  }
}
