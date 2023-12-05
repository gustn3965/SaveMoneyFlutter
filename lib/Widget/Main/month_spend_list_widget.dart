import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../DataBase/Model/NTMonth.dart';
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
class MonthSpendListWidget extends StatefulWidget {
  const MonthSpendListWidget({Key? key}) : super(key: key);

  @override
  _MonthSpendListWidgetState createState() => _MonthSpendListWidgetState();
}

class MonthSpendListModel {
  final NTSpendDay spendDay;
  int price;
  int count;

  MonthSpendListModel({
    required this.spendDay,
    required this.price,
    required this.count,
  });
}

class _MonthSpendListWidgetState extends State<MonthSpendListWidget> {
  late SaveMoneyViewModel saveMoneyViewModel;


  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);

    int totalSpend = 0;
    Map<int, MonthSpendListModel> spendList = {};
    for (NTMonth month in saveMoneyViewModel.selectedNtMonths) {
      for (NTSpendDay spendDay in month.currentNTSpendList ?? []) {
        totalSpend += spendDay.spend;
        if (spendList[spendDay.categoryId] == null) {
          spendList[spendDay.categoryId] = MonthSpendListModel(spendDay: spendDay, price: spendDay.spend, count: 1);
        } else {
          spendList[spendDay.categoryId]?.price += spendDay.spend;
          spendList[spendDay.categoryId]?.count += 1;
        }
      }
    }
    List<MonthSpendListModel> sortedList = spendList.values.toList()
      ..sort((a, b) => b.price.compareTo(a.price));


    return Column(
      children: [
        headerWidget(totalSpend),

        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: sortedList.length,
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
                                future: sortedList[index].spendDay.fetchString(),
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
                                '${NumberFormat("#,###").format(sortedList[index].price ?? 0)}원',
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
                          Text(
                            '${NumberFormat("#,###").format(sortedList[index].count ?? 0)}번',
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


  Widget headerWidget(int totalSpend) {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFE5E3E3),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '${saveMoneyViewModel.focusedDay?.month}월 요약',
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
                    totalSpend == 0 ? '소비된 내역이 없습니다.' : '${NumberFormat("#,###").format(totalSpend)}원',
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
