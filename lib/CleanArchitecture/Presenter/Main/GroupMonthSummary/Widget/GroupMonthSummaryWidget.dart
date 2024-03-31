import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Domain/Entity/GroupMonth.dart';

import '../ViewModel/GroupMonthSummaryViewModel.dart';

import 'dart:async';

class GroupMonthSummaryWidget extends StatelessWidget {
  final GroupMonthSummaryViewModel viewModel;

  const GroupMonthSummaryWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupMonthSummaryViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return contentWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildContent(GroupMonthSummaryViewModel data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Title: ${data.monthGroupTitle}'),
        Text('Planned Budget: ${data.monthGroupPlannedBudget}'),
        Text('Will Save Money: ${data.monthGroupWillSaveMoney}'),
      ],
    );
  }

  Widget contentWidget(GroupMonthSummaryViewModel viewModel) {
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
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        viewModel.monthGroupTitle,
                        style: TextStyle(
                          color: Color(0xFFFF005B),
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        '지출그룹은',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Text(
                '${viewModel.monthGroupWillSaveMoney}',
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
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽 정렬 설정
                children: [
                  const Padding(
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
                      )),
                  Padding(
                      padding:
                          const EdgeInsets.only(right: 25), // 왼쪽에 10의 패딩 추가
                      child: Text(
                        '${viewModel.monthGroupPlannedBudget}',
                        style: const TextStyle(
                          color: Colors.black,
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
                    '${500000}',
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
