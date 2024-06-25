import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topSearchWidget(),
              searchedCountWidget(),
              Expanded(
                child: ListView.builder(
                  // shrinkWrap: false,
                  // primary: false,
                  itemCount: viewModel.items.length,
                  itemBuilder: (BuildContext context, int index) {

                    SearchSpendItem item = viewModel.items[index];

                    if (item is SearchSpendItemDate) {
                      return dateHeaderWidget(item);
                    } else if (item is SearchSpendItemSpend) {
                      return spendItemWidget(item, index);
                    } else {
                      return SizedBox(height: 20);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget topSearchWidget() {
    return Container(
      height: 100,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            descriptionTextFieldWidget(),
            searchButton(),
          ],
        ),
      ),
    );
  }

  Widget searchedCountWidget() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: Text('(${viewModel.items.length} 개)', textAlign: TextAlign.start,));
  }

  // Widget searchedSpendListWidget() {
  //
  // }
  Widget descriptionTextFieldWidget() {
    return Material(
      child: Container(
        width: 200,
        height: 80,
        color: AppColors.whiteColor,
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: false,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15),
          maxLength: viewModel.maxNameLength,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: '소비 카테고리 이름',
            floatingLabelAlignment: FloatingLabelAlignment.start,
          ),
          onSubmitted: (String value) {
            viewModel.didClickSearchButton();
          },
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
          backgroundColor: AppColors.mainHightColor,
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

  Widget dateHeaderWidget(SearchSpendItemDate item) {
    return Container(
      // height: 40,
      width: MediaQuery.of(NavigationService.currentContext!).size.width,
      color: AppColors.lightGrayColor,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 왼쪽과 오른쪽 정렬 설정
            children: [
              Padding(
                  padding:
                  EdgeInsets.only(left:20, right: 10), // 왼쪽에 10의 패딩 추가
                  child: Text(
                    '${item.dateString}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
              Text(
                '(${DateFormat.EEEE('ko').format(item.date)})',
                style: TextStyle(
                  color: item.date.weekday == DateTime.sunday ? AppColors.mainRedColor : Colors.black,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget spendItemWidget(SearchSpendItemSpend item, int index) {
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
