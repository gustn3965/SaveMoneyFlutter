import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';

import '../../Extension/DateTime+Extension.dart';
import 'add_spend_group_money_widget.dart';

class AddSpendGroupWidget extends StatefulWidget {
  const AddSpendGroupWidget({ Key? key, required this.selectedDate, required this.needCancelButton}) : super(key:key);

  final DateTime selectedDate;
  final bool needCancelButton;

  @override
  State<AddSpendGroupWidget> createState() => _AddSpendGroupWidgetState();
}

class _AddSpendGroupWidgetState extends State<AddSpendGroupWidget> {

  final groupTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: GestureDetector(
                  onTap: () {
                    //FocusManager.instance.primaryFocus?.unfocus();
                    FocusScope.of(context).unfocus();
                  },

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
                            autofocus: true,
                            controller: groupTitleController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: '지출그룹 이름을 정해주세요.',
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                            ),

                            onChanged: (text) {
                              // Provider.of<AddSpendingViewModel>(context, listen: false).currentInputMoney = int.parse(text);
                              setState(() {
                                groupTitleController.text = text;
                              });

                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "지출 항목들을 포함할 \n지출 그룹을 설정합니다.",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height:1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "가능한 한,\n지출그룹을 나누는게 좋아요.",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                height:1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 50),
                            Image.asset('assets/addGroupImage.png'),
                            SizedBox(height: 60),
                            Text(
                              "변동성있는 지출그룹에서\n소비를 아껴서 돈을 모아보아요.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                          ],
                        ),

                        SizedBox(height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: makeBottomButton(),
                        )

                      ],
                    ),
                  ),
                )
            ),
          ),
        )
      ),
    );
  }

  List<Widget> makeBottomButton() {
    if (widget.needCancelButton) {
      return [cancelButton(), nextButton()];
    } else {
      return [nextButton()];
    }
  }

  Widget nextButton() {
    return FilledButton(
      onPressed: groupTitleController.text.isEmpty ? null : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSpendGroupMoneyWidget(group: NTSpendGroup(id: indexDateIdFromDateTime(DateTime.now()), name: groupTitleController.text), selectedDate: widget.selectedDate),
          ),
        );
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
