import 'dart:collection';

import 'package:flutter/material.dart';


import 'package:save_money_flutter/main.dart';
import 'package:save_money_flutter/view_model/select_date_view_model.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../DataBase/Model/NTSpendDay.dart';
import '../../view_model/save_money_view_model.dart';

// import

class Event {
  int money;
  Event(this.money);

  @override
  String toString() => '$money';
}

class MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late SaveMoneyViewModel selectDateViewModel = Provider.of<SaveMoneyViewModel>(context);

  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    List<NTSpendDay> getEventsForDay(DateTime day) {
      return selectDateViewModel.mapSpendDayList?[day] ?? [];
    }

    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
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
        calendarBuilders: CalendarBuilders(

          // selectedBuilder: (context, dateTime, _) {
          //   return Container(
          //     color: Colors.red.withAlpha(128),
          //   );
          // },
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
              List<NTSpendDay> eventList = events.cast<NTSpendDay>();
              int sum = eventList.fold(0, (previous, current) => previous + current.spend);
              int maxMoney = selectDateViewModel.selectedNtMonth?.everyExpectedSpend ?? 0;


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
            // selectDateViewModel.updateFocusedDay(selectedDay);
            selectDateViewModel.updateSelectedDay(selectedDay);
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          selectDateViewModel.updateFocusedDay(focusedDay);
          print(focusedDay);
        },
      );
  }
}
