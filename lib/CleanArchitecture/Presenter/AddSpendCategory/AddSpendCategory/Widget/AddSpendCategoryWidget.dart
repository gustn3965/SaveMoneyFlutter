import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AddSpendCategory/AddSpendCategory/ViewModel/AddSpendCategoryViewModel.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../AppCoordinator.dart';

class AddSpendCategoryWidget extends StatelessWidget {
  final AddSpendCategoryViewModel viewModel;

  late TextEditingController spendCategoryTextController;

  AddSpendCategoryWidget(this.viewModel, {super.key}) {
    spendCategoryTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<AddSpendCategoryViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return SingleChildScrollView(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      descriptionTextFieldWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      cancelAndConfirmButtons(),
                    ],
                  ),
                )));
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
          controller: spendCategoryTextController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15),
          maxLength: 40,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: '소비 카테고리 이름을 입력해주세요.',
            floatingLabelAlignment: FloatingLabelAlignment.center,
          ),
          onChanged: (text) {
            spendCategoryTextController.text = text;
            viewModel.didChangeSpendCategoryName(text);
          },
        ),
      ),
    );
  }

  Widget cancelAndConfirmButtons() {
    return Column(
      // 삭제 / 저장 버튼
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40), // 왼쪽에 10의 패딩 추가
              child: Container(
                width: MediaQuery.of(
                            NavigationService.navigatorKey.currentContext!)
                        .size
                        .width *
                    0.35,
                height: 45,
                child: ElevatedButton(
                  onPressed: (true)
                      ? () async {
                          viewModel?.didClickCancelButton();
                        }
                      : null,
                  child: Text('취소'),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 40), // 왼쪽에 10의 패딩 추가
              child: Container(
                width: MediaQuery.of(
                            NavigationService.navigatorKey.currentContext!)
                        .size
                        .width *
                    0.35,
                height: 45,
                child: ElevatedButton(
                  onPressed: (viewModel?.availableConfirmButton == true)
                      ? () async {
                          viewModel?.didClickConfirmButton();
                        }
                      : null,
                  child: Text('추가'),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF2C62F0),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}