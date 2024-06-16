import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          backgroundColor: Colors.white,
          body: PopScope(
              canPop: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      color: Colors.white,
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
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: '지출그룹 이름을 정해주세요.',
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
                              const Text(
                                "지출 항목들을 포함할 \n지출 그룹을 설정합니다.",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                "가능한 한,\n지출그룹을 나누는게 좋아요.",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 50),
                              Image.asset('assets/addGroupImage.png'),
                              const SizedBox(height: 60),
                              const Text(
                                "변동성있는 지출그룹에서\n소비를 아껴서 돈을 모아보아요.",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
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
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFA6BEFB),
        disabledBackgroundColor: const Color(0xFFD5DFF9),
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
