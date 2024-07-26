import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../AppColor/AppColors.dart';
import '../ViewModel/AppNoticeViewModel.dart';

class AppNoticeWebView extends StatefulWidget {

  final AppNoticeWebViewModel viewModel;

  AppNoticeWebView(this.viewModel);

  @override
  _AppNOticeWebViewState createState() => _AppNOticeWebViewState();
}

class _AppNOticeWebViewState extends State<AppNoticeWebView> {

  late AppNoticeWebViewModel viewModel = widget.viewModel;

  bool isLoading = true;

  late WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          if (progress < 100) {
            // 페이지가 아직 로딩 중인 경우
            setState(() {
              isLoading = true;
            });
          } else {
            // 페이지 로딩이 완료된 경우
            setState(() {
              isLoading = false;
            });
          }
        },
        onPageStarted: (String url) {
          setState(() {
            isLoading = true; // 페이지 시작 시 로딩 상태를 true로 설정
          });
        },
        onPageFinished: (String url) {
          setState(() {
            isLoading = false; // 페이지 종료 시 로딩 상태를 false로 설정
          });
        },
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.viewModel.noticeUrl));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppNoticeWebViewModel>(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: appColors.mainColor(),
                title: Text(
                  '공지사항',
                  style: TextStyle(
                    color: appColors.blackColor(),
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    height: 0,
                  ),
                ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // 사용자 정의 동작을 수행합니다.
                    viewModel.didClickNavigationPopButton();
                  }),),
            backgroundColor: appColors.whiteColor(),
            body: Stack(
              children: [
                WebViewWidget(controller: controller), // WebView를 표시
                if (isLoading) // isLoading이 true일 때 인디케이터를 표시
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(appColors.mainColor()),
                    ),
                  ),
              ],
            ),
          );
        }
    );
  }
}
