import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddGroup/AddGroupMoney/ViewModel/AddGroupMoneyViewModel.dart';
import 'package:intl/intl.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../../Extension/DateTime+Extension.dart';

class AddGroupMoneyWidget extends StatefulWidget {
  final AddGroupMoneyViewModel viewModel;

  const AddGroupMoneyWidget(this.viewModel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddGroupMoneyWidgetState();
  }
}

class _AddGroupMoneyWidgetState extends State<AddGroupMoneyWidget> {
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
    return StreamBuilder<AddGroupMoneyViewModel>(
      stream: widget.viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: appColors.whiteColor(),
          body: PopScope(
              canPop: false,
              child: SingleChildScrollView(
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
                              const SizedBox(
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
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: appColors.mainTintColor(), width: 2.0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: appColors.mainColor(), width: 1.0),
                                    ),
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
                                    widget.viewModel
                                        .didChangeEveryExpectedMoney(
                                            everyExpectedMoney);
                                  },
                                ),
                              ),
                              SizedBox(height: 50),
                              const Text(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  cancelButton(),
                                  saveButton(),
                                ],
                              ),
                              SizedBox(height: 30),
                              const Text(
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
                                    NumberFormat("#,###").format(
                                        widget.viewModel.everyExpectedMoney),
                                    style: const TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.deepOrangeAccent),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5),
                                  const Text(
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
              )),
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
        foregroundColor: appColors.constWhiteColor(),
        disabledForegroundColor: appColors.lightBlackColor(),
        backgroundColor: appColors.confirmColor(),
        disabledBackgroundColor: appColors.confirmDisableColor(),
        shape: const RoundedRectangleBorder(
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
        backgroundColor: appColors.buttonCancelColor(),
        disabledBackgroundColor: appColors.buttonDisableCancelColor(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      child: Text('    취소    '),
    );
  }
}
