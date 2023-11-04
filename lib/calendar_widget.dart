import 'package:flutter/material.dart';


import 'package:save_money_flutter/main.dart';
import 'package:save_money_flutter/view_model/select_date_view_model.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
// import

class MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late SelectDateViewModel selectDateViewModel;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    selectDateViewModel = Provider.of<SelectDateViewModel>(context);

    return TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: selectDateViewModel.focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(selectDateViewModel.selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectDateViewModel.selectedDay = selectedDay;
            selectDateViewModel.focusedDay = focusedDay;
            selectDateViewModel.updateData();
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          selectDateViewModel.focusedDay = focusedDay;
          selectDateViewModel.updateData();
          print(focusedDay);
        },
      );
  }
}
