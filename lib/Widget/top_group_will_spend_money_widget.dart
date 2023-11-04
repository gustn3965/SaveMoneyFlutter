
import 'package:flutter/material.dart';


class TopGroupWillSpendMoneyWidget extends StatelessWidget {
  final String rightText;

  TopGroupWillSpendMoneyWidget({
    required this.rightText
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFF0EEEE),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '예상 지출 금액이에요.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 40), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    rightText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  )
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}