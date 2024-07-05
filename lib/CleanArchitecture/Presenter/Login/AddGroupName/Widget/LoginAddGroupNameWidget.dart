import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../AppColor/AppColors.dart';
import '../ViewModel/LoginAddGroupNameViewModel.dart';

class LoginAddGroupNameWidget extends StatelessWidget {
  final LoginAddGroupNameViewModel viewModel;
  late TextEditingController groupTitleController;

  LoginAddGroupNameWidget(this.viewModel, {super.key}) {
    groupTitleController =
        TextEditingController(text: '${viewModel?.groupName ?? ""}');
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<LoginAddGroupNameViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: appColors.whiteColor(),
          body: PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                print(didPop);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      color: appColors.whiteColor(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Container(
                            width: 200,
                            height: 80,
                            child: TextField(
                              textAlign: TextAlign.center,
                              autofocus: true,
                              controller: groupTitleController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 20),
                              maxLength: viewModel.maxNameLength,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: appColors.mainTintColor(), width: 2.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: appColors.mainColor(), width: 1.0),
                                ),
                                labelText: '바인더 이름을 정해주세요.',
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                              ),
                              onChanged: (text) {
                                viewModel.didChangeGroupName(text);
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "변동성있는 바인더에서",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  color: appColors.mainRedColor(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                "소비를 아껴서 돈을 모아보아요.",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [nextButton()],
                          )
                        ],
                      ),
                    ),
                  )),
                ),
              )),
        );
      },
    );
  }

  Widget nextButton() {
    return FilledButton(
      onPressed: viewModel.availableConfirmButton == false
          ? null
          : () {
              viewModel.didClickConfirmButton();
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.constWhiteColor(),
        disabledForegroundColor: appColors.lightBlackColor(),
        backgroundColor: appColors.confirmColor(),
        disabledBackgroundColor: appColors.confirmDisableColor(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      child: Text('    확인    '),
    );
  }
}
