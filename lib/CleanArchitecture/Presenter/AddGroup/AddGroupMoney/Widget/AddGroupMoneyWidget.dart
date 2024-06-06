import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';
import 'package:intl/intl.dart';

import '../../../../../Extension/DateTime+Extension.dart';

class AddGroupMoneyWidget extends StatelessWidget {
  final AddGroupMoneyViewModel viewModel;

  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));
  final groupMoneyTitleController = TextEditingController();

  AddGroupMoneyWidget(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<AddGroupMoneyViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                                autofocus: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  // isCollapsed: true,
                                  border: UnderlineInputBorder(),
                                  labelText: '금액을 입력해주세요.',
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.center,
                                ),
                                onChanged: (text) {
                                  // Provider.of<AddSpendingViewModel>(context, listen: false).currentInputMoney = int.parse(text);
                                  text =
                                      '${_formatNumber(text.replaceAll(',', ''))}';
                                  groupMoneyTitleController.text = text;
                                  int date = indexMonthDateIdFromDateTime(
                                      viewModel.date);
                                  int expectedMoney =
                                      int.parse(text.replaceAll(',', ''));
                                  int everyExpectedMoney = (expectedMoney /
                                          daysInMonthFromSince1970(date))
                                      .toInt();
                                  viewModel
                                      .didChangePlannedBudget(expectedMoney);
                                  viewModel.didChangeEveryExpectedMoney(
                                      everyExpectedMoney);
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
                            SizedBox(height: 20),
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
                                  "${NumberFormat("#,###").format(viewModel.everyExpectedMoney)}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.deepOrangeAccent),
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
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget saveButton() {
    return FilledButton(
      onPressed: viewModel.availableConfirmButton == false
          ? null
          : () async {
              viewModel.didClickConfirmButton();

              // print(widget.group.name);
              // print(groupMoneyTitleController.text);
              // print(saveMoneyViewModel.allSpendCategorys);
              //
              // int date = indexMonthDateIdFromDateTime(widget.selectedDate);
              // int expectedMoney = int.parse(groupMoneyTitleController.text.replaceAll(',', ''));
              // int everyExpectedMoney = (expectedMoney / daysInMonthFromSince1970(date)).toInt();
              // NTMonth newMonth = NTMonth(id: generateUniqueId(), date: date, groupId: widget.group.id, spendType: 0, expectedSpend: expectedMoney, everyExpectedSpend: everyExpectedMoney, additionalMoney: 0);
              // await saveMoneyViewModel.addSpendGroup(widget.group);
              // await saveMoneyViewModel.addNtMonth(newMonth);
              //
              // Navigator.popUntil(context, (route) => route.isFirst);
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
      onPressed: () {
        viewModel.didClickCancelButton();
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
