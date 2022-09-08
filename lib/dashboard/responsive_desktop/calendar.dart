import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat("MMM, yyyy").format(_focusedDay),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month - 1);
                      });
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month + 1);
                      });
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010),
            lastDay: DateTime.utc(2100),
            headerVisible: false,
            onFormatChanged: (result) {},
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) {
                return DateFormat("EEE").format(date).toUpperCase();
              },
              weekendStyle: const TextStyle(fontWeight: FontWeight.bold),
              weekdayStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPageChanged: (day) {
              _focusedDay = day;
              setState(() {});
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
