

import 'package:save_money_flutter/DataBase/Model/NTSpendCategory.dart';
import 'package:save_money_flutter/Widget/AddSpendGroup/add_spend_group_money_widget.dart';
import 'package:save_money_flutter/Widget/AddSpendGroup/add_spend_group_widget.dart';
import 'package:save_money_flutter/Widget/Main/spend_group_widget.dart';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/view_model/save_money_view_model.dart';

import 'package:provider/provider.dart';

import '../../DataBase/Model/NTSpendGroup.dart';
import '../EditSpendGroup/spend_group_list_widget.dart';

class SpendCategoryWidget extends StatefulWidget {
  @override
  _SpendCategoryWidgetState createState() => _SpendCategoryWidgetState();
}

class _SpendCategoryWidgetState extends State<SpendCategoryWidget> {

  late SaveMoneyViewModel saveMoneyViewModel = Provider.of<SaveMoneyViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: 50.0,
          // color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child:
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              primary: false,
              itemCount: saveMoneyViewModel.allSpendCategorys.length,
              itemBuilder: (context, index) {
                return spendCategoryChip(saveMoneyViewModel.allSpendCategorys[index]);
              },
            ),
          ),
        );
      },
    );
  }

  // makeChipButton() {
  //   List<dynamic> chipArray = saveMoneyViewModel.ntSpendGroups.map((tag) => spendCategoryChip(tag)).toList();
  //   // chipArray.add(addSpendGroupChip());
  //   // chipArray.add(allSpendGroupChip());
  //   return chipArray;
  // }

  spendCategoryChip(NTSpendCategory categoryObject) {
    return Container(
      padding: EdgeInsets.only(left:5, right: 5),
      child: FilterChip(
          showCheckmark: false,
          // selected: saveMoneyViewModel.selectedGroups.where((element) => element.id == categoryObject.id).isNotEmpty,
          backgroundColor: Color(0xFFA6BDFA),
          selectedColor: Color(0xFF2C62F0),
          // shadowColor: Colors.grey,
          // elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          label: Text("# ${categoryObject.name}"),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(strokeAlign: 0.5),

          onSelected: (bool value) async {

            await saveMoneyViewModel.updateSpendCategoryGroups([categoryObject]);
            // bool isFind = await saveMoneyViewModel.updateSelectedGroups([categoryObject]);
            //
            // if (isFind == false) {
            //   showAddNTMonthWidget(categoryObject);
            // }
          }
      ),
    );
  }

  addSpendGroupChip() {
    return FilterChip(
        showCheckmark: false,
        selected: false,
        backgroundColor: Colors.black12,
        selectedColor: Color(0xFFFF005B),
        // shadowColor: Colors.grey,
        // elevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        label: Text("지출 그룹 수정"),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(strokeAlign: 1),


        onSelected: (bool value) {
          setState(() {
            showEditSpendGroupListWidget();
            // saveMoneyViewModel.updateSelectedGroup(groupObject);
          });
        }
    );
  }

  allSpendGroupChip() {
    return FilterChip(
        showCheckmark: false,
        selected: false,
        backgroundColor: Colors.black12,
        selectedColor: Color(0xFFFF005B),
        // shadowColor: Colors.grey,
        // elevation: 4,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text("모든 그룹"),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(strokeAlign: 1),


        onSelected: (bool value) async {

          await saveMoneyViewModel.updateSelectedGroups(saveMoneyViewModel.ntSpendGroups);
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

  showEditSpendGroupListWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpendGroupListWidget(),
      ),
    );
  }
}