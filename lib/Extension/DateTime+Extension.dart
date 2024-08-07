import 'dart:math';
import 'package:uuid/uuid.dart';

int dayFromMillisecondsSinceEpoch(int miliseconds) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(miliseconds);
  return time.day;
}

int dayFromSince1970(int since) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(since * 1000);
  return time.day;
}

int monthFromSince1970(int since) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(since * 1000);
  return time.month;
}

int yearFromSince1970(int since) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(since * 1000);
  return time.year;
}

int indexDateIdFromDateTime(DateTime dateTime) {
  print((dateTime.millisecondsSinceEpoch).toInt());
  return (dateTime.millisecondsSinceEpoch).toInt() + Random().nextInt(1000);
}

int indexMonthAndDayIdFromDateTime(DateTime dateTime) {
  DateTime dateFrom = DateTime(dateTime.year, dateTime.month, dateTime.day);

  DateTime dateFrom2 =
      DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.second);
  return (dateFrom2.millisecondsSinceEpoch / 1000).toInt();
}

int indexMonthDateIdFromDateTime(DateTime dateTime) {
  DateTime dateFrom = DateTime(dateTime.year, dateTime.month);
  return (dateFrom.millisecondsSinceEpoch / 1000).toInt();
}

int daysInMonthFromSince1970(int since) {
  DateTime time = dateTimeFromSince1970(since);
  int daysInMonth = DateTime(time.year, time.month + 1, 0).day;
  return daysInMonth;
}

int daysInDateTime(DateTime time) {
  int daysInMonth = DateTime(time.year, time.month + 1, 0).day;
  return daysInMonth;
}

// BOOL

bool isEqualDateMonth(DateTime dateTime, DateTime otherTime) {
  return dateTime.year == otherTime.year && dateTime.month == otherTime.month;
}

bool isEqualDateMonthAndDay(DateTime dateTime, DateTime otherTime) {
  return dateTime.year == otherTime.year &&
      dateTime.month == otherTime.month &&
      dateTime.day == otherTime.day;
}

// DateTime
DateTime dateTimeFromSince1970Second(int since) {
  return DateTime.fromMillisecondsSinceEpoch(since * 1000);
}

DateTime dateTimeFromSince1970(int since) {
  // return DateTime.fromMillisecondsSinceEpoch(since * 1000);
  return DateTime.fromMillisecondsSinceEpoch(since);
}

DateTime dateTimeYearMonthDaySince1970(int since) {
  DateTime dateTime = dateTimeFromSince1970(since);
  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
}

DateTime dateTimeBeforeMonth(DateTime dateTime) {
  return DateTime.utc(dateTime.year, dateTime.month - 1, dateTime.day);
}

DateTime dateTimeAfterMonth(DateTime dateTime) {
  return DateTime.utc(dateTime.year, dateTime.month + 1, dateTime.day);
}

DateTime dateTimeAfterDay(DateTime dateTime, int afterDay) {
  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day + afterDay);
}

DateTime dateTimeAfterMonthDay(
    DateTime dateTime, int afterMonth, int afterDay) {
  return DateTime.utc(
      dateTime.year, dateTime.month + afterMonth, dateTime.day + afterDay);
}

String generateUniqueId() {
  return const Uuid().v4(); // timestamp
}
