import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';


AppColors appColors = AppColors();

class AppColors {
  // 블루

  bool isDarkMode() {
    return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }
  Color mainLighColor() {
    if (isDarkMode()) {
      return Color(0xFF1D5BFC);
    } else {
      return Color(0xFFC0CFF6);
    }
  }

  Color whiteColor() {
    if (isDarkMode()) {
      return Color(0xFF000000);
    } else {
      return Color(0xFFFFFFFF);
    }
  }

  Color lightGrayColor() {
    if (isDarkMode()) {
      return Color(0xFF414141);
    } else {
      return Color(0xFFBEBEBE);
    }
  }

  Color blackColor() {
    if (isDarkMode()) {
      return Color(0xFFFFFFFF);
    } else {
      return Color(0xFF000000);
    }
  }

  Color mainColor() {
    if (isDarkMode()) {
      return Color(0xFF4071F3);
    } else {
      return Color(0xFFA6BDFA);
    }
  }

  Color mainHightColor() {
    if (isDarkMode()) {
      return Color(0xFF9FB5EF);
    } else {
      return Color(0xFF2C62F0);
    }
  }

  Color mainHightDisableColor() {
    if (isDarkMode()) {
      return Color(0xFF2C3E73);
    } else {
      return Color(0xFF99B3F5);
    }
  }

  Color mainRedColor() {
    if (isDarkMode()) {
      return Color(0xFFC90040);
    } else {
      return Color(0xFFFF2171);
    }
  }

  // static Color mainLighColor = Color(0xFFC0CFF6);

  // static Color mainColor = Color(0xFFA6BDFA); // 원하는 색상으로 초기화

  // static Color mainHightColor = Color(0xFF2C62F0);

  //레드
  // static Color mainRedColor = Color(0xFFFF005B);

  // 검은색바탕
  // static Color lightGrayColor = Colors.black12;

  static Color lightDarkColor = Color(0xFF2F2F2F);

  // 흰색바탕
  // static Color whiteColor = appColors.whiteColor();

  static Color whitelightGrayColor = Color(0xFFF1F1F1);

  static Color editColorGray = Color(0xFFC4C1C1);

  static Color deepGrayColor = Color(0xFFC4C1C1);

}
