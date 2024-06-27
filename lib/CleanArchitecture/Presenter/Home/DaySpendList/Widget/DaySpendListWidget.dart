import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/DaySpendList/ViewModel/DaySpendListViewModel.dart';
import 'package:intl/intl.dart';

class DaySpendListWidget extends StatelessWidget {
  DaySpendListViewModel viewModel;

  DaySpendListWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DaySpendListViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (viewModel.spendList.length == 0) {
          return Container(
            color: appColors.whiteColor(),
            child: Column(
              children: [
                headerWidget(),
                SizedBox(height: 40),
              ],
            ),
          );
        } else {
          return Container(
            color: appColors.whiteColor(),
            child: Column(
              children: [
                headerWidget(),
                dayListWidget(),
                SizedBox(height: 40),
              ],
            ),
          );
        }
      },
    );
  }

  Widget headerWidget() {
    return Container(
      // height: 65,
      width: MediaQuery.of(NavigationService.currentContext!).size.width,
      color: appColors.lightGrayColor(),
      child: Column(
        children: [
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 10), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '${viewModel.date.month}월${viewModel.date.day}일 (${viewModel.spendList.length})',
                    style: TextStyle(
                      color: appColors.blackColor(),
                      fontSize: 18,
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
                        : '${NumberFormat("#,###").format(viewModel.totalSpendMoney)}원',
                    style: TextStyle(
                      color: appColors.blackColor(),
                      fontSize: 18,
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
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget dayListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: viewModel.spendList.length,
      itemBuilder: (BuildContext context, int index) {
        DaySpendListViewModelItem item = viewModel.spendList[index];
        return Container(
          // height: 100,
          // padding: const EdgeInsets.only(bottom: 30),
          color: appColors.whiteColor(),
          width: MediaQuery.of(context).size.width,
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
                                color: appColors.blackColor(),
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
                          foregroundColor: appColors.blackColor(),
                          backgroundColor: AppColors.editColorGray,
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
    );
  }
}
