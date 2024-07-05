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

Color generateUniqueColor(String uuid) {
// UUID의 여러 부분을 사용하여 RGB 값을 생성
  String cleanUuid = uuid.replaceAll('-', '');
  if (cleanUuid.length < 24) {
    return Colors.black;
  }
// UUID의 여러 부분을 사용하여 RGB 값을 생성
  String redHex = cleanUuid.substring(0, 8); // 첫 8자리
  String greenHex = cleanUuid.substring(8, 16); // 다음 8자리
  String blueHex = cleanUuid.substring(16, 24); // 다음 8자리

  // 16진수 문자열을 정수로 변환 후, 8비트로 맞춤
  int red = (int.parse(redHex, radix: 16) % 256);
  int green = (int.parse(greenHex, radix: 16) % 256);
  int blue = (int.parse(blueHex, radix: 16) % 256);

  // Color 객체 생성
  return Color.fromARGB(255, red, green, blue);

  return Color.fromARGB(255, red, green, blue);
}

Color darkColor(Color color) {
  final hsl = HSLColor.fromColor(color);
  final darkenedHsl = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0));
  return darkenedHsl.toColor();
}