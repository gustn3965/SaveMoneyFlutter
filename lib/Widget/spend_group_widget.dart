
import 'package:save_money_flutter/Widget/spend_group_widget.dart';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';

import 'package:provider/provider.dart';

class SpendGroupWidget extends StatefulWidget {
  @override
  _SpendGroupWidgetState createState() => _SpendGroupWidgetState();
}

class _SpendGroupWidgetState extends State<SpendGroupWidget> {

  late SaveMoneyViewModel saveMoneyViewModel;

  var selected_tags = [];

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
    return saveMoneyViewModel.groups.map((tag) => get_chip(tag)).toList();
  }

  get_chip(GroupObject groupObject) {
    return FilterChip(
      selected: selected_tags.contains(groupObject.name),
      backgroundColor: Color(0xFFFAA6A6),
      selectedColor: Color(0xFFFF005B),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label: Text("${groupObject.name}"),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,

      onSelected: (bool value) {
        if (groupObject.type == ObjectType.plusButton) {
          // Plus 버튼을 눌렀을 때의 동작
          setState(() {
            saveMoneyViewModel.groups.insert(saveMoneyViewModel.groups.length - 1,
                GroupObject(name: "샘플", type: ObjectType.group, group: Group(willSpendMoney: 4230000, spendMoney: 400000, name: "샘플")));
            saveMoneyViewModel.updateData();
          });
        } else {
          setState(() {
            if (selected_tags.contains(groupObject.name)) {
              
            } else {
              if (selected_tags.isEmpty == false) {
                selected_tags.removeLast();
              }
              selected_tags.add(groupObject.name);
              saveMoneyViewModel.selectedGroup = groupObject.group;
            }

            saveMoneyViewModel.updateData();
          });
        }
      },
    );
  }
}