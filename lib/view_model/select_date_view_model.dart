
import 'package:flutter/cupertino.dart';

class SelectDateViewModel extends ChangeNotifier {
  DateTime focusedDay = DateTime.now(); // 현재 보고 있는 날짜
  DateTime selectedDay = DateTime.now(); // 현재 선택한 날짜

  void updateData() {
    notifyListeners();
  }
}