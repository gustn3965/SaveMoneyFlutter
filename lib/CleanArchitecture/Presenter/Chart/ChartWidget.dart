import 'package:flutter/material.dart';
import 'package:save_money_flutter/AppColor/AppColors.dart';

class ChartWidget extends StatelessWidget {
  final List<Widget> widgets;

  const ChartWidget({Key? key, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }
}
