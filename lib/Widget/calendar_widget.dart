import 'dart:collection';

import 'package:flutter/material.dart';


import 'package:save_money_flutter/main.dart';
import 'package:save_money_flutter/view_model/select_date_view_model.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// import

class Event {
  int money;
  Event(this.money);

  @override
  String toString() => '$money';
}

Map<DateTime,dynamic> eventSource = {
  DateTime.utc(2023,11,2) : [Event(2000), Event(50000),],
  DateTime.utc(2023,11,3) : [Event(2000),Event(2000),Event(2000), Event(200000), Event(10000)],
  DateTime.utc(2023,11,5) : [Event(2000), Event(20000),],
  DateTime.utc(2023,11,8) : [Event(2000), Event(2000000),],
  DateTime.utc(2023,11,8) : [Event(2000), Event(40000000),],
  DateTime.utc(2023,11,9) : [Event(2000), Event(52000),],
  DateTime.utc(2023,11,11) : [Event(0)],
  DateTime.utc(2023,11,12) : [Event(5000)],
  DateTime.utc(2023,11,13) : [Event(23000)],
  DateTime.utc(2023,11,23) : [Event(5000), Event(200000)],
  // DateTime.utc(2023,11,13) : [Event('5분 기도하기',false),Event('교회 가서 인증샷 찍기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  // DateTime.utc(2023,11,15) : [Event('5분 기도하기',false),Event('치킨 먹기',false),Event('QT하기',true),Event('셀 모임하기',false),],
  // DateTime.utc(2023,11,18) : [Event('5분 기도하기',false),Event('자기 셀카 올리기',true),Event('QT하기',false),Event('셀 모임하기',false),],
  // DateTime.utc(2023,11,20) : [Event('5분 기도하기',true),Event('자기 셀카 올리기',true),Event('QT하기',true),Event('셀 모임하기',true),],
  // DateTime.utc(2023,11,21) : [Event('5분 기도하기',false),Event('가족과 저녁식사 하기',true),Event('QT하기',false)]
};

class MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late SelectDateViewModel selectDateViewModel;
  final events = eventSource;


  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    selectDateViewModel = Provider.of<SelectDateViewModel>(context);

    List<Event> getEventsForDay(DateTime day) {
      return events[day] ?? [];
    }

    return TableCalendar(
      availableCalendarFormats: {CalendarFormat.month: 'Month'},
        locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: selectDateViewModel.focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(selectDateViewModel.selectedDay, day);
        },
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
        eventLoader: (day) {
            return getEventsForDay(day);
        },
      // calendarStyle: CalendarStyle(
      //   markerSize: 10.0,
      //   markerDecoration: BoxDecoration(
      //       color: Colors.red,
      //       shape: BoxShape.circle
      //   ),
      // ),
      calendarBuilders: CalendarBuilders(
          // selectedBuilder: (context, dateTime, _) {
          //   return Container(
          //     color: Colors.red.withAlpha(128),
          //   );
          // },
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
              List<Event> eventList = events.cast<Event>();
              int sum = eventList.fold(0, (previous, current) => previous + current.money);
              int maxMoney = 100000;


              String moneyFormatted = NumberFormat("#,###")
                  .format(sum);
              return Padding(
                padding: const EdgeInsets.only(left: 3, right: 3),
                child: Container(
                    // width: 24,
                    // height: MediaQuery.of(context).size.height * 0.1,
                    alignment: Alignment.bottomCenter,
                    // decoration: BoxDecoration(color: Colors.lightBlue),
                    child: Text(
                            '${moneyFormatted}',
                            maxLines: 1,

                            style: TextStyle(
                                color: (sum > maxMoney) ? Colors.red : Colors.blue,
                                fontWeight: FontWeight.w700,
                                fontSize: 10),
                        ),
                    ),
              );
          } else {
            return null;
          }
        }
      ),
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
