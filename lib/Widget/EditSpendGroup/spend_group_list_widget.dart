import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:save_money_flutter/DataBase/Model/NTSpendGroup.dart';
import 'package:save_money_flutter/Widget/EditSpendGroup/spend_group_edit_month_list_widget.dart';
import '../../AppColor/AppColors.dart';
import '../../DataBase/Model/NTSpendDay.dart';
import '../../view_model/add_spending_view_model.dart';
import '../../view_model/save_money_view_model.dart';
import '../AddSpendGroup/add_spend_group_money_widget.dart';
import '../AddSpendGroup/add_spend_group_widget.dart';
import '../AddSpending/add_spending_widget.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class SpendGroupListWidget extends StatefulWidget {
  const SpendGroupListWidget({super.key});

  @override
  State<SpendGroupListWidget> createState() => _SpendGroupListWidgetState();
}

class _SpendGroupListWidgetState extends State<SpendGroupListWidget> {
  late SaveMoneyViewModel saveMoneyViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text(
            '지출 그룹 변경',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          )),
      body: FutureBuilder<List<NTSpendGroup>>(
        future: saveMoneyViewModel.fetchNTSpendGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return addGroupButton();
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 동안 오류가 발생했습니다.'));
          } else {
            // 데이터를 성공적으로 가져온 경우의 화면
            final List<NTSpendGroup>? spendGroups = snapshot.data;

            return ListView.builder(
              itemCount: (spendGroups?.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (index < (spendGroups?.length ?? 0)) {
                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),
                    closeOnScroll: true,
                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const BehindMotion(),
                      extentRatio: 0.3,
                      // A pane can dismiss the Slidable.
                      // dismissible: DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (context) {
                            if (spendGroups?[index] != null) {
                              showDeleteSpendGroupAlert(spendGroups![index]);
                            }
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '삭제',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, top: 15, bottom: 10),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ), //  POINT: BoxDecoration
                          child: Text(
                            spendGroups?[index].name ?? '',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 20, top: 10),
                          // padding: const EdgeInsets.all(10.0),
                          child: FilledButton(
                            onPressed: () {
                              if (spendGroups?[index] != null) {
                                showEditNTMonthWidget(spendGroups![index]);
                              }
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
                            child: Text('금액 수정'),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return addGroupButton();
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget addGroupButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: FilledButton(
          onPressed: () {
            showAddNTMonthWidget();
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
          child: Text('    지출 그룹 추가하기    '),
        ),
      ),
    );
  }

  showAddNTMonthWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSpendGroupWidget(
            selectedDate: saveMoneyViewModel.focusedDay,
            needCancelButton: true),
      ),
    );
  }

  showEditNTMonthWidget(NTSpendGroup spendGroup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpendGroupDayListWidget(spendGroup: spendGroup),
      ),
    );
  }

  showDeleteSpendGroupAlert(NTSpendGroup spendGroup) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          '${spendGroup.name} 지출그룹 삭제',
        ),
        content: const Text('해당 지출내역들이 모두 삭제됩니다.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('아니오'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await saveMoneyViewModel.deleteNtMonthsBy(spendGroup);
              await saveMoneyViewModel.deleteNTSpendGroup(spendGroup);
              Navigator.pop(context);
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
