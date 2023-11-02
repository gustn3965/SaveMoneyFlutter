
import 'package:flutter/material.dart';

enum ObjectType {
  group,
  plusButton,
}

// 객체 클래스 정의
class GroupObject {
  final String name;
  final ObjectType type;

  GroupObject({
    required this.name,
    required this.type,
  });
}

class SpendGroupWidget extends StatefulWidget {
  @override
  _SpendGroupWidgetState createState() => _SpendGroupWidgetState();
}

class _SpendGroupWidgetState extends State<SpendGroupWidget> {
  var groups = [
    GroupObject(name: "고정지출 비용", type: ObjectType.group),
    GroupObject(name: "chip 버튼", type: ObjectType.group),
    GroupObject(name: "나를 위한 선물 나를튼", type: ObjectType.group),
    GroupObject(name: "버튼", type: ObjectType.group),
    GroupObject(name: "추가 +", type: ObjectType.plusButton),
  ];

  var selected_tags = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          color: Color(0xFFADABAB),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              color: Color(0xFFADABAB),
              child: Column(
                children: [
                  SizedBox(height:10),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 4.0,
                    children: <Widget>[...generate_tags()],
                  ),
                  SizedBox(height:10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  generate_tags() {
    return groups.map((tag) => get_chip(tag)).toList();
  }

  get_chip(GroupObject groupObject) {
    return FilterChip(
      selected: selected_tags.contains(groupObject.name),
      backgroundColor: Color(0xFFFAA6A6),
      selectedColor: Color(0xFFFF005B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      label: Text("${groupObject.name}"),
      onSelected: (bool value) {
        if (groupObject.type == ObjectType.plusButton) {
          // Plus 버튼을 눌렀을 때의 동작
          setState(() {
            groups.insert(groups.length - 1,
                GroupObject(name: "샘플", type: ObjectType.group));
          });
        } else {
          setState(() {
            if (selected_tags.contains(groupObject.name)) {
              
            } else {
              if (selected_tags.isEmpty == false) {
                selected_tags.removeLast();
              }
              selected_tags.add(groupObject.name);

            }
          });
        }
      },
    );
  }
}