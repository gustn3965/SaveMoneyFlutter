


import 'package:flutter/cupertino.dart';

class SaveMoneyViewModel extends ChangeNotifier {
  List<GroupObject> groups;
  int spendMoney;
  int willSpendMoney;

  Group? selectedGroup;

  SaveMoneyViewModel({
    required this.groups,
    required this.spendMoney,
    required this.willSpendMoney,
  }) : selectedGroup = groups.map((target) => target.group ).first;


  void updateData() {
    notifyListeners();
  }
}

enum ObjectType {
  group,
  plusButton,
}



// 객체 클래스 정의
class GroupObject {
  final String name;
  final ObjectType type;

  Group? group;

  GroupObject({
    required this.name,
    required this.type,
    required this.group,
  });
}


class Group {
  final String name;
  int spendMoney;
  int willSpendMoney;

  Group({
    required this.name,
    required this.spendMoney,
    required this.willSpendMoney,
  });
}