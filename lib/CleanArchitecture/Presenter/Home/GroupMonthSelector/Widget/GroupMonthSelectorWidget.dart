import 'package:flutter/material.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../Domain/Entity/GroupMonth.dart';
import '../ViewModel/GroupMonthSelectorViewModel.dart';

class GroupMonthSelectorWidget extends StatelessWidget {
  final GroupMonthSelectorViewModel viewModel;

  const GroupMonthSelectorWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupMonthSelectorViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              color: appColors.whiteColor(),
              width: constraints.maxWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: <Widget>[..._makeChipButton(viewModel)],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _makeChipButton(GroupMonthSelectorViewModel viewModel) {
    List<dynamic> chipArray = [];
    for (var groupObject in viewModel.groupMonthList) {
      chipArray.add(_spendGroupChip(groupObject, viewModel));
    }
    chipArray.add(_addSpendGroupChip(viewModel));
    chipArray.add(_addEnableMultiSelectGroupChip(viewModel));
    return chipArray;
  }

  _spendGroupChip(
      GroupMonth groupObject, GroupMonthSelectorViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: FilterChip(
        showCheckmark: false,
        selected: viewModel.selectedGroupMonths.contains(groupObject),
        backgroundColor: appColors.whiteColor(),
        selectedColor: appColors.mainRedColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text("${groupObject.groupCategory.name}",
            style: TextStyle(color: appColors.blackColor())),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(width: 1, color: appColors.blackColor()),
        onSelected: (bool value) async {
          viewModel.didSelectGroupMonth(groupObject);
        },
      ),
    );
  }

  Widget _addSpendGroupChip(GroupMonthSelectorViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: FilterChip(
        showCheckmark: false,
        selected: false,
        backgroundColor: appColors.lightGrayColor(),
        selectedColor: Color(0xFFFF005B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        label: Text(viewModel.addGroupButtonName),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(width: 1, color: appColors.blackColor()),
        onSelected: (bool value) {
          viewModel.didSelectAddGroupMonth();
        },
      ),
    );
  }

  Widget _addEnableMultiSelectGroupChip(GroupMonthSelectorViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: FilterChip(
        showCheckmark: false,
        selected: viewModel.enableMultiSelectChip,
        backgroundColor: appColors.whiteColor(),
        selectedColor: appColors.mainColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        label: Text(viewModel.enableMultiSelectChipName),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(width: 1, color: appColors.blackColor()),
        onSelected: (bool value) {
          viewModel.didSelectEnableMultiSelectChip(value);
        },
      ),
    );
  }
}
