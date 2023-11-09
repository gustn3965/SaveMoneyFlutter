
import 'package:save_money_flutter/Widget/AddSpendGroup/add_spend_group_money_widget.dart';
import 'package:save_money_flutter/Widget/AddSpendGroup/add_spend_group_widget.dart';
import 'package:save_money_flutter/Widget/Main/spend_group_widget.dart';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';

import 'package:provider/provider.dart';

import '../../DataBase/Model/NTSpendGroup.dart';

class SpendGroupWidget extends StatefulWidget {
  @override
  _SpendGroupWidgetState createState() => _SpendGroupWidgetState();
}

class _SpendGroupWidgetState extends State<SpendGroupWidget> {

  late SaveMoneyViewModel saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          // color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              // color: Color(0xFFADABAB),
              child: Column(
                children: [
                  SizedBox(height:15),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: <Widget>[...makeChipButton()],
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

  makeChipButton() {
    List<dynamic> chipArray = saveMoneyViewModel.ntSpendGroups.map((tag) => spendGroupChip(tag)).toList();
    chipArray.add(addSpendGroupChip());
    return chipArray;
  }

  spendGroupChip(NTSpendGroup groupObject) {
    return FilterChip(
      showCheckmark: false,
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

      onSelected: (bool value) async {

          bool isFind = await saveMoneyViewModel.updateSelectedGroup(groupObject);

          if (isFind == false) {
            showAddNTMonthWidget(groupObject);
          }
        }
    );
  }

  addSpendGroupChip() {
    return FilterChip(
        showCheckmark: false,
        selected: false,
        backgroundColor: Color(0xFFA6BDFA),
        selectedColor: Color(0xFFFF005B),
        shadowColor: Colors.grey,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        label: Text("지출 그룹 +"),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide.none,

        onSelected: (bool value) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSpendGroupWidget(selectedDate: saveMoneyViewModel.focusedDay, needCancelButton: true),
              ),
            );
            // saveMoneyViewModel.updateSelectedGroup(groupObject);
          });
        }
    );
  }

  showAddNTMonthWidget(NTSpendGroup group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSpendGroupMoneyWidget(group: group, selectedDate: saveMoneyViewModel.focusedDay),
      ),
    );
  }
}