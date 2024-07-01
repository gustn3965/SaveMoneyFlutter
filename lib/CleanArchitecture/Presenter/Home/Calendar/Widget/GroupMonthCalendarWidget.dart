import 'package:flutter/material.dart';
import 'package:save_money_flutter/Extension/DateTime+Extension.dart';

import '../../../../../AppColor/AppColors.dart';
import '../../../../Domain/Entity/Spend.dart';
import '../ViewModel/GroupMonthCalendarViewModel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class GroupMonthCalendarWidget extends StatelessWidget {
  final GroupMonthCalendarViewModel viewModel;

  const GroupMonthCalendarWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupMonthCalendarViewModel>(
      stream: viewModel.dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // 데이터가 있는 경우
          return _buildCalendar(context, snapshot.data!);
        } else if (snapshot.hasError) {
          // 에러가 있는 경우
          return Text('Error: ${snapshot.error}');
        } else {
          // 데이터가 로딩 중인 경우
          return _buildCalendar(context, viewModel);
        }
      },
    );
  }

  Widget _buildCalendar(
      BuildContext context, GroupMonthCalendarViewModel viewModel) {
    initializeDateFormatting();
    CalendarFormat _calendarFormat = CalendarFormat.month;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color: appColors.whiteColor(),
        child: TableCalendar(
          availableGestures: AvailableGestures.horizontalSwipe,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          locale: 'ko_KR',
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: viewModel.focuseDate,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(viewModel.selectedDate ?? DateTime.now(), day);
          },
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          eventLoader: (day) {
            return viewModel.spendList[day] ?? [];
          },
          calendarBuilders: CalendarBuilders(

              // selectedBuilder: (context, dateTime, _) {
              //   return Container(
              //     color: Colors.red.withAlpha(128),
              //   );
              // },
              markerBuilder: (context, day, events) {
            if (events.isNotEmpty) {
              List<Spend> eventList = events.cast<Spend>();
              int sum = eventList.fold(
                  0, (previous, current) => previous + current.spendMoney);
              int maxMoney = viewModel.plannedBudgeEveryDay;
              bool isOverSpend = sum > maxMoney;
              String moneyFormatted = NumberFormat("#,###").format(sum);

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
                        // color: (sum > maxMoney) ? Colors.red : Colors.blue,
                        color: isOverSpend ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.w700,
                        fontSize: 10),
                  ),
                ),
              );
            } else {
              return null;
            }
          }),
          onDaySelected: (selectedDay, focusedDay) {
            if (isEqualDateMonth(selectedDay, focusedDay)) {
              viewModel.didSelectDate(selectedDay);
            } else {
              viewModel.didSelectDate(selectedDay);
              viewModel.didChangeMonth(selectedDay);
            }
          },
          onFormatChanged: (format) {
            // setState(() {
            //   _calendarFormat = format;
            // });
          },
          onPageChanged: (focusedDay) {
            viewModel.didChangeMonth(focusedDay);
          },
        ),
      ),
    );
  }
}
