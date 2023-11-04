import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SpendingModel {
  DateTime date;
  String spendCategory;
  String description;
  int spendMoney;

  SpendingModel(this.date, this.spendCategory, this.description, this.spendMoney);

}
class SpendListWidget extends StatefulWidget {
  const SpendListWidget({Key? key}) : super(key: key);

  @override
  _SpendListWidgetState createState() => _SpendListWidgetState();
}


class _SpendListWidgetState extends State<SpendListWidget> {

  List<SpendingModel> spendList = [SpendingModel(DateTime.now(),"담배", "", 4800),
    SpendingModel(DateTime.now(),"여가생활", "테니스 2시간 했습니다...", 20000),
    SpendingModel(DateTime.now(),"커피", "", 1800),
    SpendingModel(DateTime.now(),"옷", "가을 옷 준비!", 14800),
    SpendingModel(DateTime.now(),"담배", "", 4800)];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                        '11/2',
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
                        "400,000",
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
        ),
        ListView.builder(
          shrinkWrap: true,
            primary: false,
            itemCount: spendList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                // height: 100,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 15),
                            Text(
                              spendList[index].spendCategory,
                              style: TextStyle(
                                color: Color(0xFF0082FB),
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
                              '${spendList[index].spendMoney}',
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
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
