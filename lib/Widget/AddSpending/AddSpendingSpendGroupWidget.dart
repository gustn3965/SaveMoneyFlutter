
import 'package:save_money_flutter/Widget/Main/spend_group_widget.dart';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';

import 'package:provider/provider.dart';

import '../../DataBase/Model/NTSpendGroup.dart';
import '../../view_model/add_spending_view_model.dart';



class AddSpendingSpendGroupWidget extends StatefulWidget {
  @override
  _AddSpendingSpendGroupWidgetState createState() => _AddSpendingSpendGroupWidgetState();
}

class _AddSpendingSpendGroupWidgetState extends State<AddSpendingSpendGroupWidget> {


  late AddSpendingViewModel spendingViewModel = Provider.of<AddSpendingViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          // color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Container(
              // color: Color(0xFFADABAB),
              child: Column(
                children: [
                  SizedBox(height:15),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: <Widget>[...generate_tags()],
                  ),
                  SizedBox(height:15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  generate_tags() {
    return spendingViewModel.ntSpendGroups.map((tag) => get_chip(tag)).toList();
  }

  get_chip(NTSpendGroup groupObject) {
    return FilterChip(
        showCheckmark: false,
        selected: groupObject.id == spendingViewModel.selectedGroup?.id,
        backgroundColor: Color(0xFFFAA6A6),
        selectedColor: Color(0xFFFF005B),
        shadowColor: Colors.grey,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text("${groupObject.name}"),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide.none,

        onSelected: (bool value) async {
          // if (groupObject.type == ObjectType.plusButton) {
          //   // Plus 버튼을 눌렀을 때의 동작
          //   setState(() {
          //     // saveMoneyViewModel.ntSpendGroups.insert(saveMoneyViewModel.ntSpendGroups.length - 1,
          //     //     GroupObject(name: "샘플", type: ObjectType.group, group: Group(willSpendMoney: 4230000, spendMoney: 400000, name: "샘플")));
          //     // saveMoneyViewModel.updateData();
          //   });
          // } else {
          await spendingViewModel.updateSelectedGroup(groupObject);
          // setState(() async {
          //
          // });
        }
      // },
    );
  }
}