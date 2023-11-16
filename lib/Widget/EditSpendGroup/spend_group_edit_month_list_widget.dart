
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Widget/EditSpendGroup/edit_spend_group_money_widget.dart';
import '../../DataBase/Model/NTMonth.dart';
import '../../DataBase/Model/NTSpendDay.dart';
import '../../view_model/add_spending_view_model.dart';
import '../../view_model/save_money_view_model.dart';
import '../AddSpendGroup/add_spend_group_money_widget.dart';
import '../AddSpendGroup/add_spend_group_widget.dart';
import '../AddSpending/add_spending_widget.dart';



class SpendGroupDayListWidget extends StatefulWidget {
  const SpendGroupDayListWidget({Key? key, required this.spendGroup}) : super(key:key);

  final NTSpendGroup spendGroup;

  @override
  State<SpendGroupDayListWidget> createState() => _SpendGroupDayListWidgetState();
}

class _SpendGroupDayListWidgetState extends State<SpendGroupDayListWidget> {

  late NTMonth? selectedNtMonth = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              "수정하고자 하는 날짜를 선택해주세요.",
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height:20),
            TextButton(
                onPressed: () async {
                  _showDatePicker();
                },
                child: Text(
                    selectedNtMonth?.dateStringYYMM() ?? '>클릭해주세요<',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      height: 0,
                    )
                )
            ),
            SizedBox(height:20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cancelButton(),
                nextButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return FilledButton(
      onPressed: selectedNtMonth == null ? null : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditSpendGroupMoneyWidget(month: selectedNtMonth!),
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

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          color: Colors.white,
          child: FutureBuilder<List<NTMonth>>(
            future: widget.spendGroup.ntMonths(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 데이터를 아직 가져오고 있을 때의 화면
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // 오류가 발생한 경우의 화면
                return Center(child: Text('데이터를 불러오는 동안 오류가 발생했습니다.'));
              } else {
                // 데이터를 성공적으로 가져온 경우의 화면
                final List<NTMonth>? data = snapshot.data;

                return CupertinoPicker.builder(
                    itemExtent: 50,
                    childCount: data?.length,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        // timeString = time[i];
                        selectedNtMonth = data?[index];
                      });
                    },

                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              // timeString = time[i];
                              selectedNtMonth = data?[index];
                            });
                        }, child: Text(
                        data?[index].dateStringYYMM() ?? '',
                      )
                      );
                    }
                );
              }
            },
          ),
        );
      },
    );
  }
}
