import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../DataBase/Model/NTSpendDay.dart';
import '../../view_model/add_spending_view_model.dart';
import '../../view_model/save_money_view_model.dart';
import '../AddSpending/add_spending_widget.dart';



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
  late SaveMoneyViewModel saveMoneyViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);

    int totalSpend = 0;
    for (NTSpendDay spendDay in saveMoneyViewModel.selectedNtSpendList ?? []) {
      totalSpend += spendDay.spend;
    }
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
                        '${saveMoneyViewModel.selectedDay?.month}/${saveMoneyViewModel.selectedDay?.day}',
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
                        totalSpend == 0 ? '소비된 내역이 없습니다.' : '${NumberFormat("#,###").format(totalSpend)}',
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
            itemCount: saveMoneyViewModel.selectedNtSpendList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                // height: 100,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 15),
                                FutureBuilder<String>(
                                  future: saveMoneyViewModel.selectedNtSpendList?[index].fetchString(),
                                  builder: (context, snapshot) {
                                    String name = snapshot.data ?? '';
                                    return Text(
                                      name,
                                      style: TextStyle(
                                        color: Color(0xFF0082FB),
                                        fontSize: 20,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.0,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                    );
                                  },
                                ),

                                SizedBox(height: 10),
                                Text(
                                  '${NumberFormat("#,###").format(saveMoneyViewModel.selectedNtSpendList?[index].spend ?? 0)}원',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    height: 1.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                            FilledButton(
                              onPressed: () {
                                _showEditAddSpendCategory(saveMoneyViewModel.selectedNtSpendList![index]);
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

                              child: Text('수정'),
                            )
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

  void _showEditAddSpendCategory(NTSpendDay spendDay) async {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(27))),
      builder: (BuildContext context) {
        return ChangeNotifierProvider (
            create: (context) {
              AddSpendingViewModel viewModel = AddSpendingViewModel();
              viewModel.setupByExistSpendDay(spendDay, saveMoneyViewModel);
              return viewModel;
            }, child: Container(
            height:
            MediaQuery.of(context).size.height * 0.9, // 모달 다이얼로그의 높이를 설정
            child: AddSpendingWidget(spendDay: spendDay))
        );

      },
    );
  }
}
