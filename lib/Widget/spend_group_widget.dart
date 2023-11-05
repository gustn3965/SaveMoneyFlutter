
import 'package:save_money_flutter/Widget/spend_group_widget.dart';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';

import 'package:provider/provider.dart';

import '../DataBase/Model/NTSpendGroup.dart';

class SpendGroupWidget extends StatefulWidget {
  @override
  _SpendGroupWidgetState createState() => _SpendGroupWidgetState();
}

class _SpendGroupWidgetState extends State<SpendGroupWidget> {

  late SaveMoneyViewModel saveMoneyViewModel;

  @override
  Widget build(BuildContext context) {
    saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          // color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
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
    return saveMoneyViewModel.ntSpendGroups.map((tag) => get_chip(tag)).toList();
  }

  get_chip(NTSpendGroup groupObject) {
    return FilterChip(
      selected: groupObject.id == saveMoneyViewModel.selectedGroup?.id,
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

      onSelected: (bool value) {
        // if (groupObject.type == ObjectType.plusButton) {
        //   // Plus 버튼을 눌렀을 때의 동작
        //   setState(() {
        //     // saveMoneyViewModel.ntSpendGroups.insert(saveMoneyViewModel.ntSpendGroups.length - 1,
        //     //     GroupObject(name: "샘플", type: ObjectType.group, group: Group(willSpendMoney: 4230000, spendMoney: 400000, name: "샘플")));
        //     // saveMoneyViewModel.updateData();
        //   });
        // } else {
          setState(() {

              saveMoneyViewModel.updateSelectedGroup(groupObject);
          });
        }
      // },
    );
  }
}