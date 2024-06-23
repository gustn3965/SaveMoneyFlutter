import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Home/SpendCategorySelector/ViewModel/SpendCategorySelectorViewModel.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../../Extension/Color+Extension.dart';

class SpendCategorySelectorWidget extends StatelessWidget {
  final SpendCategorySelectorViewModel viewModel;

  const SpendCategorySelectorWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SpendCategorySelectorViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (viewModel.items.length == 0) {
          return Column(
            children: [
              Text('소비된 카테고리가 없습니다.', style: TextStyle(fontSize: 18)),
            ],
          );
        } else {
          return Column(
            children: [
              Text('소비된 카테고리 ${viewModel.items.length}개',
                  style: TextStyle(fontSize: 18)),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    height: 50.0,
                    // color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: viewModel.items.length,
                        itemBuilder: (context, index) {
                          return spendCategoryChip(viewModel.items[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  _makeChipButton(SpendCategorySelectorViewModel viewModel) {
    List<dynamic> chipArray = [];
    for (var item in viewModel.items) {
      chipArray.add(spendCategoryChip(item));
    }

    return chipArray;
  }

  spendCategoryChip(SpendCategorySelectorItemModel item) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: FilterChip(
          showCheckmark: false,
          selected: viewModel.selectedItems.contains(item),
          backgroundColor: AppColors.whitelightGrayColor,
          selectedColor: generateUniqueColor(item.categoryId),
          // shadowColor: Colors.grey,
          // elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          label: Text("# ${item.categoryName} (${item.count})"),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(strokeAlign: 0.5),
          onSelected: (bool value) async {
            viewModel.didSelectSpendItem(item);
            // bool isFind = await saveMoneyViewModel.updateSelectedGroups([categoryObject]);
            //
            // if (isFind == false) {
            //   showAddNTMonthWidget(categoryObject);
            // }
          }),
    );
  }
}
