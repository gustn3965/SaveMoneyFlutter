import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';

import '../../../../../AppColor/AppColors.dart';
import '../ViewModel/GroupMonthSummaryViewModel.dart';
import 'package:intl/intl.dart';

class GroupMonthSummaryWidget extends StatelessWidget {
  final GroupMonthSummaryViewModel viewModel;

  const GroupMonthSummaryWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupMonthSummaryViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (viewModel.monthGroupTitle.isEmpty) {
          return Container(
            color: appColors.whiteColor(),
            child: SizedBox(
              height: 120,
              child: Center(
                  child: Text(
                '선택한 바인더가 없습니다.',
                style: TextStyle(
                  color: appColors.blackColor(),
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              )),
            ),
          );
        } else {
          return contentWidget(viewModel);
        }
      },
    );
  }

  Widget contentWidget(GroupMonthSummaryViewModel viewModel) {
    return Container(
      color: appColors.whiteColor(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          '${viewModel.monthGroupTitle ?? ""}',
                          style: TextStyle(
                            color: Color(0xFFFF005B),
                            fontSize: 22,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    // SizedBox(width: 2), // Padding을 위한 공간
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 100, // 원하는 최대 너비를 설정할 수 있습니다
                      ),
                      child: Text(
                        '바인더는',
                        style: TextStyle(
                          color: appColors.blackColor(),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(width: 10), // Padding을 위한 공간
                  ],
                ),
                SizedBox(height: 13),
                Text(
                  '${NumberFormat("#,###").format(viewModel.monthGroupWillSaveMoney)}',
                  style: TextStyle(
                    color: viewModel.monthGroupWillSaveMoneyTextColor,
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
                  viewModel.moneyDescription,
                  style: TextStyle(
                    color: appColors.blackColor(),
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
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 25), // 왼쪽에 10의 패딩 추가
                        child: Text(
                          '설정한 금액이에요.',
                          style: TextStyle(
                            color: appColors.blackColor(),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        )),
                    Padding(
                        padding:
                            const EdgeInsets.only(right: 25), // 왼쪽에 10의 패딩 추가
                        child: Text(
                          '${NumberFormat("#,###").format(viewModel.monthGroupPlannedBudget)}',
                          style: TextStyle(
                            color: appColors.blackColor(),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '매일 소비예정 (${NumberFormat("#,###").format(viewModel.monthGroupPlannedBudgetByEveryday)})',
                      style: TextStyle(
                        color: appColors.blackColor(),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '총 소비금액 (${NumberFormat("#,###").format(viewModel.monthTotalSpendMoney)})',
                      style: TextStyle(
                        color: appColors.blackColor(),
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
      ),
    );
  }
}
