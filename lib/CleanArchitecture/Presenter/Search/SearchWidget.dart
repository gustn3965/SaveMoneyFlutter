
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }
}