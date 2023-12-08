
import 'dart:math';
import 'package:flutter/material.dart';

Color getRandomColor() {
  Random random = Random();
  int r = random.nextInt(256); // 0부터 255까지의 랜덤한 숫자
  int g = random.nextInt(256);
  int b = random.nextInt(256);
  return Color.fromRGBO(r, g, b, 1.0);
}

Color uniqueColorFromIndex(int index) {
  int r = (index / 11).toInt() % 256;
  int g = (index / 8).toInt() % 256;
  int b = (index / 7).toInt() % 256;
  return Color.fromRGBO(r, g, b, 1.0);
}