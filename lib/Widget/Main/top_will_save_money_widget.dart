
import 'package:flutter/material.dart';


class TopWillSaveMoneyWidget extends StatelessWidget {
  final String groupNameText;
  final String groupWillSaveMoneyText;
  final String descriptionText;
  final String willSpendMoneyText;
  final String willEverySpendMoneyText;
  final Color moneyColor;


  TopWillSaveMoneyWidget({
    required this.groupNameText,
    required this.groupWillSaveMoneyText,
    required this.descriptionText,
    required this.willSpendMoneyText,
    required this.willEverySpendMoneyText,
    required this.moneyColor,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    groupNameText,
                    style: TextStyle(
                      color: Color(0xFFFF005B),
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '지출그룹은',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
              SizedBox(height: 13),
              Text(
                groupWillSaveMoneyText,
                style: TextStyle(
                  color: moneyColor,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text(
                descriptionText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 25), // 왼쪽에 10의 패딩 추가
                      child: Text(
                        '설정한 금액이에요.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 25), // 왼쪽에 10의 패딩 추가
                      child: Text(
                        willSpendMoneyText,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      willEverySpendMoneyText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                  ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}