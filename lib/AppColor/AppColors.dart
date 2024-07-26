import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_money_flutter/CleanArchitecture/Presenter/AppCoordinator.dart';


AppColors appColors = AppColors();

class AppColors {
  // 블루

  bool isDarkMode() {
    return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }

  // main color
  Color mainRedColor() {
    if (isDarkMode()) {
      return Color(0xFFC90040);
    } else {
      return Color(0xFFFA0058);
    }
  }

  Color mainLighColor() {
    if (isDarkMode()) {
      return Color(0xFF1D5BFC);
    } else {
      return Color(0xFFC0CFF6);
    }
  }

  Color mainColor() {
    if (isDarkMode()) {
      return Color(0xFF4071F3);
    } else {
      return Color(0xFFA6BDFA);
    }
  }

  Color mainTintColor() {
    if (isDarkMode()) {
      return Color(0xFF0F50FF);
    } else {
      return Color(0xFF547EF5);
    }
  }

  Color mainHightColor() {
    if (isDarkMode()) {
      return Color(0xFF7F9EF8);
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


  // -----------------------------------------------------







  // white
  Color whiteColor() {
    if (isDarkMode()) {
      return Color(0xFF000000);
    } else {
      return Color(0xFFFFFFFF);
    }
  }

  Color constWhiteColor() {
    return Color(0xFFFFFFFF);
  }

  // gray
  Color lightGrayColor() {
    if (isDarkMode()) {
      return Color(0xFF414141);
    } else {
      return Color(0xFFBEBEBE);
    }
  }

  //
  Color whiteAlphaColor() {
    if (isDarkMode()) {
      return Color(0x1AFFFFFF);
    } else {
      return Color(0xFFFFFF);
    }
  }


  // back
  Color blackColor() {
    if (isDarkMode()) {
      return Color(0xFFFFFFFF);
    } else {
      return Color(0xFF000000);
    }
  }

  Color lightBlackColor() {
    if (isDarkMode()) {
      return Color(0xFFABA8A8);
    } else {
      return Color(0xFF2F2F2F);
    }
  }

  Color constBlackColor() {
    return Color(0xFF000000);
  }









  // button delete
  Color deleteButton() {
    if (isDarkMode()) {
      return Color(0xFFD30344);
    } else {
      return Color(0xFFEF0C51);
    }
  }
  Color deleteDisableButton() {
    if (isDarkMode()) {
      return Color(0xFFAB6A7E);
    } else {
      return Color(0xFFEC98B3);
    }
  }


  // button confirm, save,
  Color confirmColor() {
    if (isDarkMode()) {
      return Color(0xFF0B4BF3);
    } else {
      return Color(0xFF1D5BFC);
    }
  }
  Color confirmDisableColor() {
    if (isDarkMode()) {
      return Color(0xFF1A2F72);
    } else {
      return Color(0xFF8DAAF3);
    }
  }
  Color confirmNormalColor() {
    if (isDarkMode()) {
      return Color(0xFF5E8AFA);
    } else {
      return Color(0xFF769AFA);
    }
  }


  // button edit
  Color editColorGray() {
    if (isDarkMode()) {
      return Color(0xFF706E6E);
    } else {
      return Color(0xFFC4C1C1);
    }
  }

  // button edit
  Color editDisableColorGray() {
    if (isDarkMode()) {
      return Color(0xFFADABAB);
    } else {
      return Color(0xFF4F4E4E);
    }
  }



  // button cancel
  Color buttonCancelColor() {
    if (isDarkMode()) {
      return Color(0xFF575759);
    } else {
      return Color(0xFF575759);
    }
  }

  Color buttonDisableCancelColor() {
    if (isDarkMode()) {
      return Color(0xFF8A8A8A);
    } else {
      return Color(0xFF8A8A8A);
    }
  }

  // static Color mainLighColor = Color(0xFFC0CFF6);

  // static Color mainColor = Color(0xFFA6BDFA); // 원하는 색상으로 초기화

  // static Color mainHightColor = Color(0xFF2C62F0);

  //레드
  // static Color mainRedColor = Color(0xFFFF005B);

  // 검은색바탕
  // static Color lightGrayColor = Colors.black12;

  // static Color lightDarkColor = Color(0xFF2F2F2F);

  // 흰색바탕
  // static Color whiteColor = appColors.whiteColor();

  static Color whitelightGrayColor = Color(0xFFF1F1F1);

  // static Color editColorGray = Color(0xFFC4C1C1);

  static Color deepGrayColor = Color(0xFFC4C1C1);

}
