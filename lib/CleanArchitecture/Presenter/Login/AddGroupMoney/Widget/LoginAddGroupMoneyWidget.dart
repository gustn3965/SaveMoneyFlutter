import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../../Extension/DateTime+Extension.dart';
import '../ViewModel/LoginAddGroupMoneyViewModel.dart';

class LoginAddGroupMoneyWidget extends StatefulWidget {
  final LoginAddGroupMoneyViewModel viewModel;

  const LoginAddGroupMoneyWidget(this.viewModel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginAddGroupMoneyWidgetState();
  }
}

class _LoginAddGroupMoneyWidgetState extends State<LoginAddGroupMoneyWidget> {
  late TextEditingController groupMoneyTitleController;
  String _formatNumber(String s) => NumberFormat("#,###").format(int.parse(s));

  @override
  void initState() {
    super.initState();
    groupMoneyTitleController = TextEditingController(
      text: NumberFormat("#,###").format(widget.viewModel?.plannedBudget ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<LoginAddGroupMoneyViewModel>(
      stream: widget.viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: appColors.whiteColor(),
          body: SingleChildScrollView(
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Container(
                      color: appColors.whiteColor(),
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
                                if (text == '') {
                                  text = "0";
                                } else if (int.parse(text) > 99999999999) { // 천억
                                  text = "99999999999";
                                }
                                text =
                                    '${_formatNumber(text.replaceAll(',', ''))}';
                                groupMoneyTitleController.text = text;
                                int date = indexMonthDateIdFromDateTime(
                                    widget.viewModel.date);
                                int expectedMoney =
                                    int.parse(text.replaceAll(',', ''));
                                int everyExpectedMoney = (expectedMoney /
                                        daysInMonthFromSince1970(date))
                                    .toInt();
                                widget.viewModel
                                    .didChangePlannedBudget(expectedMoney);
                                widget.viewModel.didChangeEveryExpectedMoney(
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
                                "${NumberFormat("#,###").format(widget.viewModel.everyExpectedMoney)}",
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
      },
    );
  }

  Widget saveButton() {
    return FilledButton(
      onPressed: widget.viewModel.availableConfirmButton == false
          ? null
          : () async {
              widget.viewModel.didClickConfirmButton();
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.blackColor(),
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
        widget.viewModel.didClickCancelButton();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.whiteColor(),
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
