import 'dart:convert';

import 'package:billing/widgets/toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  static String routeName = '/Dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

List<bool> isSelected = [true, false];

class _DashboardState extends State<Dashboard> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Dashboard ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.calendar_month)
                    ],
                  ),
                  Container(
                    height: 35,
                    child: ToggleButtons(
                      children: <Widget>[Text("Orders"), Text("Item")],
                      selectedColor: Colors.white,
                      color: Colors.purple,
                      fillColor: Colors.purple,
                      borderColor: Colors.purple,
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelected,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TableCalendar(
                    firstDay: DateTime.utc(1000, 3, 14),
                    lastDay: DateTime.utc(2090, 3, 14),
                    availableGestures: AvailableGestures.all,
                    calendarBuilders: calendarBuilder(),
                    focusedDay: DateTime.now(),
                    // eventLoader: _getEventsForDay,
                    calendarFormat: CalendarFormat.week,
                    /*   selectedDayPredicate: (day) {
                      return isSameDay(day, day);
                    }, */
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        /*     select = true;
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay; */
                      });
                    },
                    onPageChanged: (focusedDay) {
                      //_focusedDay = focusedDay;
                    },
                    daysOfWeekVisible: false,
                    rowHeight: 80,

                    /*  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.fromBorderSide(BorderSide(
                              width: 0.5, color: Color(0xFF000000)))),
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 18.0),
                    ), */
                    headerVisible: false,
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 50,
                      outsideDaysVisible: true,
                      cellPadding: const EdgeInsets.all(10.0),
                      weekendDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300]!.withOpacity(0.6)),
                      holidayDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300]!.withOpacity(0.6)),
                      defaultDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300]!.withOpacity(0.6)),
                      cellMargin: const EdgeInsets.all(3.0),
                      /*  rowDecoration: BoxDecoration(
                        color: Colors.white,
                      ), */
                      defaultTextStyle: const TextStyle(
                          fontSize: 17, color: Color(0Xff000000)),
                      weekendTextStyle: const TextStyle(
                          fontSize: 17, color: Color(0Xff000000)),
                      holidayTextStyle: const TextStyle(
                          fontSize: 17, color: Color(0Xff000000)),
                      todayTextStyle:
                          const TextStyle(fontSize: 17, color: Colors.purple),
                      todayDecoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.purple)),
                      /*    selectedDecoration: const BoxDecoration(
                        color: Color(0Xff46b04a),
                      ), */
                    ))),
          ],
        ),
      ),
    );
  }

  CalendarBuilders calendarBuilder() {
    return CalendarBuilders(
      markerBuilder: (
        context,
        date,
        events,
      ) {
        //  if (events.isNotEmpty) {
        return Container(
          child: _buildEventsMarkerNum(date),
        );
        // }
        // return null;
      },
    );
  }

  Widget _buildEventsMarkerNum(DateTime day) {
    return buildCalendarDay(text: '${0}', day: day);
  }

  Widget buildCalendarDay({
    required String text,
    required DateTime day,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.center,
          // margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          width: 29,
          height: 29,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              dateFormatter(day),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  String dateFormatter(DateTime date) {
    dynamic dayData =
        '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

    return json.decode(dayData)['${date.weekday}'];
  }
}
