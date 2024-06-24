import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/Search/SearchSpend/ViewModel/SearchSpendViewModel.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../AppCoordinator.dart';

class SearchSpendWidget extends StatelessWidget {
  final SearchSpendViewModel viewModel;

  SearchSpendWidget(this.viewModel, {super.key}) {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<SearchSpendViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 10, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  descriptionTextFieldWidget(),
                  searchButton(),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: viewModel.items.length,
              itemBuilder: (BuildContext context, int index) {
                SearchSpendItem item = viewModel.items[index];

                return spendItemWidget(item, index);
              },
            )
          ],
        );
      },
    );
  }

  Widget descriptionTextFieldWidget() {
    return Material(
      child: Container(
        width: 200,
        height: 80,
        color: AppColors.whiteColor,
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15),
          maxLength: viewModel.maxNameLength,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: '소비 카테고리 이름',
            floatingLabelAlignment: FloatingLabelAlignment.start,
          ),
          onChanged: (text) {
            viewModel.didChangeSearchName(text);
          },
        ),
      ),
    );
  }

  Widget searchButton() {
    return ElevatedButton.icon(
      onPressed: (true)
          ? () async {
              viewModel.didClickSearchButton();
            }
          : null,
      icon: Icon(Icons.search), // 검색 아이콘
      label: Text('검색'), // 버튼 텍스트
      style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.whiteColor,
          backgroundColor: AppColors.mainColor,
          // 버튼의 배경색을 파란색으로 설정
          // textStyle: TextStyle(color: AppColors.whiteColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // 모서리 반경 설정
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          // 패딩 설정
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent // 물방울 효과 제거
          ),
    );
  }

  Widget spendItemWidget(SearchSpendItem item, int index) {
    return Container(
      // height: 100,
      width: MediaQuery.of(NavigationService.currentContext!).size.width,
      child: Stack(
        children: [
          Align(
            // alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          item.spendCategoryName,
                          style: const TextStyle(
                            color: Color(0xFF0082FB),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        if (item.dateString.isNotEmpty)
                          Text("날짜 : ${item.dateString}"),
                        if (item.description.isNotEmpty)
                          Text("설명 : ${item.description}"),
                        SizedBox(height: 10),
                        Text(
                          item.spendMoneyString,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      viewModel.didClickEditSpendItem(item);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: AppColors.editColorGray,
                      disabledBackgroundColor: Color(0xFFD5DFF9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Text('수정'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
