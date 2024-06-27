import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

class ChartWidget extends StatelessWidget {
  final List<Widget> widgets;

  const ChartWidget({Key? key, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '차트',
          style: TextStyle(
            color: appColors.blackColor(),
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            height: 0,
          ),
        ),
        backgroundColor: appColors.mainColor(),
      ),
      backgroundColor: appColors.whiteColor(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }
}
