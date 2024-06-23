
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:intl/intl.dart';

import '../ViewModel/MonthSpendListViewModel.dart';

class MonthSpendListWidget extends StatelessWidget {
  MonthSpendListViewModel viewModel;

  MonthSpendListWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MonthSpendListViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (viewModel.spendList.length == 0) {
          return Column(
            children: [
              headerWidget(),
              SizedBox(height: 40),
            ],
          );
        } else {
          return Column(
            children: [
              headerWidget(),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: viewModel.spendList.length,
                itemBuilder: (BuildContext context, int index) {
                  MonthSpendListItem item = viewModel.spendList[index];

                  if (item is MonthSpendListItemDate) {
                    return dateHeaderWidget(item);
                  } else if (item is MonthSpendListItemSpend) {
                    return spendItemWidget(item, index);
                  } else {
                    return SizedBox(height: 20);
                  }

                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget headerWidget() {
    return Container(
      // height: 65,
      width: MediaQuery.of(NavigationService.currentContext!).size.width,
      color: AppColors.mainColor,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding:
                  EdgeInsets.only(left: 20, right: 10), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '월 소비 목록 (${viewModel.onlyItemListCount()})',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Text(
                    viewModel.totalSpendMoney == 0
                        ? '소비된 내역이 없습니다.'
                        : '총 ${NumberFormat("#,###").format(viewModel.totalSpendMoney)}원',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget dateHeaderWidget(MonthSpendListItemDate item) {
    return Container(
      // height: 40,
      width: MediaQuery.of(NavigationService.currentContext!).size.width,
      color: AppColors.lightGrayColor,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding:
                  EdgeInsets.only(left:20, right: 10), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '${item.date.month}월${item.date.day}일',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
              Text(
                '(${DateFormat.EEEE('ko').format(item.date)})',
                style: TextStyle(
                  color: item.date.weekday == DateTime.sunday ? AppColors.mainRedColor : Colors.black,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget spendItemWidget(MonthSpendListItemSpend item, int index) {
    return Container(
      // height: 100,
      width: MediaQuery.of(NavigationService.currentContext!).size.width,
      child: Stack(
        children: [
          Align(
            // alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          item.categoryName,
                          style: const TextStyle(
                            color: Color(0xFF0082FB),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.description.isNotEmpty)
                          Text("설명 : ${item.description}"),
                        SizedBox(height: 10),
                        Text(
                          '${NumberFormat("#,###").format(item.spendMoney)}원',
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
                  ),
                  FilledButton(
                    onPressed: () {
                      viewModel.didClickModifySpendItem(index);
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
  }
}
