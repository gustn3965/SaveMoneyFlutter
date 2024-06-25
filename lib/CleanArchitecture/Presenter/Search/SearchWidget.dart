import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../AppColor/AppColors.dart';

class SearchWidget extends StatelessWidget {
  final List<Widget> widgets;

  SearchWidget({required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '검색',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          ),
          backgroundColor: AppColors.mainColor,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            // 🧡 추후에  더생긴다면 아래의 ScrollView로 바꾸고, SearchSpendWidget의 ListView는 Expanded가 아닌 Container로 감싸서 높이지정해주기.
            children: widgets,
          ),
        )
        // body: SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: widgets,
        //   ),
        // ),
        );
  }
}
