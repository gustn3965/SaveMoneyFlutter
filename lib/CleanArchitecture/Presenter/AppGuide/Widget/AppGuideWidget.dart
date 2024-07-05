import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';
import 'package:intl/intl.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppGuide/ViewModel/AppGuideViewModel.dart';


class AppGuideWidget extends StatefulWidget {

  final AppGuideViewModel viewModel;
  const AppGuideWidget(this.viewModel, {super.key});

  @override
  _AppGuideWidgetState createState() => _AppGuideWidgetState();
}

class _AppGuideWidgetState extends State<AppGuideWidget> {
  late AppGuideViewModel viewModel = widget.viewModel;

  int _step = 0;

  void _nextStep() {
    setState(() {
      if (_step + 1 > 16) {
        _step = 16;

      } else {
        HapticFeedback.mediumImpact();
        _step += 1;
      }
    });
  }
  void _prevStep() {
    setState(() {
      if (_step - 1 < 0) {
        _step = 0;
      } else {
        HapticFeedback.mediumImpact();
        _step -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: StreamBuilder<AppGuideViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          return  Scaffold(
            backgroundColor: appColors.whiteColor(),
            body: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  // Prevent back navigation on swipe
                }
              },
              onTap: _nextStep,
              behavior: HitTestBehavior.translucent, // 터치 이벤트를 더 넓게 적용
              child: Column(
                children: [
                  Flexible(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (_step == 0) _buildFirstText(0),
                                    if (_step == 1)
                                      Column(
                                        children: [
                                          _buildFirstText(1),
                                          _buildSecondText(1),
                                          _buildSecondButton(1),
                                        ],
                                      ),
                                    if (_step == 2)
                                      Column(
                                        children: [
                                          _buildFirstText(2),
                                          _buildSecondText(2),
                                          _buildThirdText(2),
                                          _buildThirdButton(2),
                                        ],
                                      ),
                                    if (_step == 3)
                                      Column(
                                        children: [
                                          _buildSecondPhaseText(3),
                                          _buildSecondPhaseButton(3),
                                        ],
                                      ),
                                    if (_step == 4)
                                      Column(
                                        children: [
                                          _buildSecondPhaseText(4),
                                          _buildSecondPhaseButton2(4),
                                        ],
                                      ),
                                    if (_step == 5)
                                      Column(
                                        children: [
                                          _buildSecondPhaseText(5),
                                          _buildSecondPhaseButton2(5),
                                          _buildSecondPhaseText3(5)
                                        ],
                                      ),
                                    if (_step == 6)
                                      Column(
                                        children: [
                                          _buildSecondPhaseText(6),
                                          _buildSecondPhaseButton2(6),
                                          _buildSecondPhaseText3(6),
                                          _buildSecondPhaseText4(6),
                                        ],
                                      ),


                                    // Phase 3
                                    if (_step == 7)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              7, "저희 앱에서는 아래처럼 표시할거에요."),
                                        ],
                                      ),
                                    if (_step == 8)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              8, "저희 앱에서는 아래처럼 표시할거에요. "),
                                          _buildThirdPhaseQuestionText1(
                                              8, "오늘 소비를 하지 않았다면 ?"),
                                        ],
                                      ),
                                    if (_step == 9)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              9, "저희 앱에서는 아래처럼 표시할거에요. "),
                                          _buildThirdPhaseQuestionText1(
                                              9, "Q1. 오늘 소비를 하지 않았다면 ?"),
                                          _buildThirdPhaseText2(index: 9,
                                              saveMoney: 10000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                        ],
                                      ),
                                    if (_step == 10)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              10, "저희 앱에서는 아래처럼 표시할거에요. "),
                                          _buildThirdPhaseQuestionText1(
                                              10, "Q1. 오늘 소비를 하지 않았다면 ?"),
                                          _buildThirdPhaseText2(index: 10,
                                              saveMoney: 10000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                          _buildThirdPhaseQuestionText1(
                                              10, "Q2. 오늘 5천원 소비를 했다면 ?"),
                                        ],
                                      ),
                                    if (_step == 11)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              11, "저희 앱에서는 아래처럼 표시할거에요. "),
                                          _buildThirdPhaseQuestionText1(
                                              11, "Q1. 오늘 소비를 하지 않았다면 ?"),
                                          _buildThirdPhaseText2(index: 11,
                                              saveMoney: 10000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                          _buildThirdPhaseQuestionText1(
                                              11, "Q2. 오늘 5천원 소비를 했다면 ?"),
                                          _buildThirdPhaseText2(index: 11,
                                              saveMoney: 5000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                        ],
                                      ),
                                    if (_step == 12)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              12, "저희 앱에서는 아래처럼 표시할거에요. "),
                                          _buildThirdPhaseQuestionText1(
                                              12, "Q1. 오늘 소비를 하지 않았다면 ?"),
                                          _buildThirdPhaseText2(index: 12,
                                              saveMoney: 10000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                          _buildThirdPhaseQuestionText1(
                                              12, "Q2. 오늘 5천원 소비를 했다면 ?"),
                                          _buildThirdPhaseText2(index: 12,
                                              saveMoney: 5000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                          _buildThirdPhaseQuestionText1(
                                              12, "Q3. 오늘 2만원 소비를 했다면 ?"),
                                        ],
                                      ),

                                    if (_step == 13)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(
                                              13, "저희 앱에서는 아래처럼 표시할거에요. "),
                                          _buildThirdPhaseQuestionText1(
                                              13, "Q1. 오늘 소비를 하지 않았다면 ?"),
                                          _buildThirdPhaseText2(index: 13,
                                              saveMoney: 10000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                          _buildThirdPhaseQuestionText1(
                                              13, "Q2. 오늘 5천원 소비를 했다면 ?"),
                                          _buildThirdPhaseText2(index: 13,
                                              saveMoney: 5000,
                                              moneyColor: appColors
                                                  .mainTintColor(),
                                              descriptionText: "돈을 모을 예정이에요👍"),
                                          _buildThirdPhaseQuestionText1(
                                              13, "Q3. 오늘 2만원 소비를 했다면 ?"),
                                          _buildThirdPhaseText2(index: 13,
                                              saveMoney: 10000,
                                              moneyColor: appColors
                                                  .mainRedColor(),
                                              descriptionText: "돈이 나갈 예정이에요😢"),
                                        ],
                                      ),


                                    // Phase 4
                                    if (_step == 14)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(14,
                                              "이렇게 남은 예산보다\n얼마나 돈을 모을수 있는지에 중점을 두었어요."),
                                        ],
                                      ),
                                    if (_step == 15)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(15,
                                              "이렇게 남은 예산보다\n얼마나 돈을 모을수 있는지에 중점을 두었어요."),
                                          _buildThirdPhaseText1(15,
                                              "변동성있는 바인더별로 예산을 설정해서, \n돈을 모아봐요!"),
                                        ],
                                      ),

                                    if (_step == 16)
                                      Column(
                                        children: [
                                          _buildThirdPhaseText1(16,
                                              "이렇게 남은 예산보다\n얼마나 돈을 모을수 있는지에 중점을 두었어요."),
                                          _buildThirdPhaseText1(16,
                                              "변동성있는 바인더별로 예산을 설정해서, \n돈을 모아봐요!"),
                                          startButton(16),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  directButtons(),
                ],
              ),
            ),
          );
        }
        )
          );
  }

  Widget directButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(),
            SizedBox(width: 20,),
            nextButton()
          ],
        ),
        SizedBox(height: 20,),
      ],
    );
  }
  Widget backButton() {
    return FilledButton(
      onPressed: () {
        _prevStep();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.whiteColor(),
        backgroundColor: appColors.buttonCancelColor(),
        disabledBackgroundColor: appColors.buttonDisableCancelColor(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      child: const Icon(
        Icons.arrow_back, // 왼쪽 화살표 아이콘
        size: 24, // 아이콘 크기
      ),
    );
  }
  Widget nextButton() {
    return FilledButton(
        onPressed:  () async {
          _nextStep();
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
        child: const Icon(
          Icons.arrow_forward, // 왼쪽 화살표 아이콘
          size: 24, // 아이콘 크기
        ),
    );
  }
  Widget _buildFirstText(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        // width: 100,
        height: 100,
        child: Center(
          child: Text(
            '현금바인더를 아시나요?',
            style: TextStyle(color: appColors.blackColor(), fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondText(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        // width: 100,
        height: 50,
        child: Center(
          child: Text(
            '월급을',
            style: TextStyle(color: appColors.blackColor(), fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildThirdText(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: Container(
        // width: 100,
        height: 50,
        child: Center(
          child: Text(
            '바인더별로 분류하는거에요.',
            style: TextStyle(color: appColors.blackColor(), fontSize: 20),
          ),
        ),
      ),
    );
  }

  // 월급 컨테이너 (두 번째 단계에서 재사용)
  Widget _buildSecondButton(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 1.0,
            child: child,
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: appColors.blackColor(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '월급',
            style: TextStyle(color: appColors.whiteColor(), fontSize: 20),
          ),
        ),
      ),
    );
  }

  // 두 번째 단계: 3개의 비용 컨테이너가 나타남
  Widget _buildThirdButton(int index) {
    return Center(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(-10 * value, 0),
              child: Opacity(
                opacity: value,
                child: _buildCostContainer('개인비용'),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0 * value, 0),
              child: Opacity(
                opacity: value,
                child: _buildCostContainer('데이트비용'),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(10 * value, 0),
              child: Opacity(
                opacity: value,
                child: _buildCostContainer('자동차비용'),
              ),
            );
          },
        ),
      ],
      ),
    );
  }


  Widget _buildSecondPhaseText(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        // width: 100,
        height: 100,
        child: Center(
          child: Text(
            '각 바인더에 예산을 설정해요.',
            style: TextStyle(color: appColors.blackColor(), fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondPhaseButton(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCostContainer("개인비용"),

          ],
        ),
      )
    );
  }

  Widget _buildSecondPhaseButton2(int index) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(-10 * value, 0),
                    child: Opacity(
                      opacity: value,
                      child: _buildCostContainer('개인비용'),
                    ),
                  );
                },
              ),
              SizedBox(width: 30,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(-10 * value, 0),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        '300,000원',
                        style: TextStyle(color: appColors.blackColor(), fontSize: 20),
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        )
    );
  }

  Widget _buildSecondPhaseText3(int index) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 30,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(-10 * value, 0),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        '30만원으로 설정했다면...',
                        style: TextStyle(color: appColors.blackColor(), fontSize: 20),
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        )
    );
  }

  Widget _buildSecondPhaseText4(int index) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(-10 * value, 0),
                    child: Opacity(
                      opacity: value,
                      child: Column(
                        children: [
                          Text(
                            "소비를 아껴서 매일",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: appColors.blackColor(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${NumberFormat("#,###").format(10000)}",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.deepOrangeAccent),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "원을 모아봐요.💪🏻",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: appColors.blackColor(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        )
    );
  }


  Widget _buildThirdPhaseText1(int index, String text) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: appColors.blackColor(), fontSize: 20, ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )
    );
  }

  Widget _buildThirdPhaseQuestionText1(int index, String text) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Opacity(
                      opacity: value,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: appColors.blackColor(), fontSize: 20 , fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )
    );
  }

  Widget _buildThirdPhaseText2({required int index, required int saveMoney, required Color moneyColor, required String descriptionText}) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 5,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Opacity(
                      opacity: value,
                      child: Column(
                        children: [
                          Text(
                            '${moneyColor == appColors.mainRedColor() ? '-' : '+' }${NumberFormat("#,###").format(saveMoney)}원',
                            style: TextStyle(
                              color: moneyColor,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          SizedBox(height: 10),
                          Text(
                            descriptionText,
                            style: TextStyle(
                              color: appColors.blackColor(),
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      )
                    ),
                  );
                },
              ),
            ],
          ),
        )
    );
  }

  Widget startButton(int index) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _step == index ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 5,),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _step == index ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Opacity(
                        opacity: value,
                        child: Column(
                          children: [
                            SizedBox(height: 30,),
                            FilledButton(
                              onPressed: () {
                                setState(() {
                                  viewModel.clickStartButton();
                                });
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
                              child: Text('    시작하기    '),
                            ),
                          ],
                        )
                    ),
                  );
                },
              ),
            ],
          ),
        )
    );
  }



  // 비용 컨테이너 위젯
  Widget _buildCostContainer(String text) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: appColors.blackColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: appColors.whiteColor(), fontSize: 16),
        ),
      ),
    );
  }
}