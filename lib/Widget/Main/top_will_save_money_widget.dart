
import 'package:flutter/material.dart';


class TopWillSaveMoneyWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color color;

  TopWillSaveMoneyWidget({
    required this.firstText,
    required this.secondText,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                firstText,
                style: TextStyle(
                  color: color,
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
                secondText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}