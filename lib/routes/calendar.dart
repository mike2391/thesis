import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/calendar_model.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // late Map<DateTime, List<Event>> selectedEvents;
  late List<DataCalendar> events;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final DateFormat dateFormat = DateFormat("MM/dd/yyyy");
  final DatabaseReference eventReference = FirebaseDatabase.instance.ref().child('event');
  final DatabaseReference projectReference = FirebaseDatabase.instance.ref().child('project');
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    // selectedEvents = {};
    events = [];
    super.initState();
    // fetchEventsFromDatabase();
    // fetchProjectFromDatabase();
    _setupDatabaseListeners();
  }

  void _setupDatabaseListeners() {
    eventReference.onValue.listen((event) {
      _updateEvents(event.snapshot);
    });

    projectReference.onValue.listen((event) {
      _updateProjects(event.snapshot);
    });
  }

  // List<DataCalendar> _getEventsFromDay(DateTime date) {
  //   return events.where((event) => date.isAfter(event.date.subtract(Duration(days:0))) && date.isBefore(event.endDate.add(Duration(days: 1)))).toList();
  // }
  //
  // Future<void> fetchEventsFromDatabase() async {
  //   DataSnapshot snapshot = await eventReference.get();
  //   if (snapshot.exists) {
  //     Map<dynamic, dynamic> eventsData = snapshot.value as Map<dynamic, dynamic>;
  //     eventsData.forEach((key, value) {
  //       String title = value['title'];
  //       DateTime startDate = dateFormat.parse(value['startDate']);
  //       DateTime endDate = dateFormat.parse(value['endDate']);
  //       startDate = DateTime(startDate.year, startDate.month, startDate.day);
  //       endDate = DateTime(endDate.year, endDate.month, endDate.day);
  //
  //       if (DateTime.now().isAfter(startDate.subtract(Duration(days: 1))) && DateTime.now().isBefore(endDate.add(Duration(days: 1)))) {
  //         DataCalendar event = DataCalendar(title: 'Event: $title', date: startDate, endDate: endDate);
  //         events.add(event);
  //       }
  //     });
  //   }
  //   setState(() {});
  // }
  //
  // Future<void> fetchProjectFromDatabase() async {
  //   DataSnapshot snapshot = await projectReference.get();
  //   if (snapshot.exists) {
  //     Map<dynamic, dynamic> eventsData = snapshot.value as Map<dynamic, dynamic>;
  //     eventsData.forEach((key, value) {
  //       String title = value['title'];
  //       DateTime startDate = dateFormat.parse(value['startDate']);
  //       DateTime endDate = dateFormat.parse(value['endDate']);
  //       startDate = DateTime(startDate.year, startDate.month, startDate.day);
  //       endDate = DateTime(endDate.year, endDate.month, endDate.day);
  //
  //       if (DateTime.now().isAfter(startDate.subtract(Duration(days: 1))) && DateTime.now().isBefore(endDate.add(Duration(days: 1)))) {
  //         DataCalendar event = DataCalendar(title: 'Project: $title', date: startDate, endDate: endDate);
  //         events.add(event);
  //       }
  //     });
  //   }
  //   setState(() {});
  // }

  void _updateEvents(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic> eventsData = snapshot.value as Map<dynamic, dynamic>;
      events.clear();
      eventsData.forEach((key, value) {
        String title = value['title'];
        DateTime startDate = dateFormat.parse(value['startDate']);
        DateTime endDate = dateFormat.parse(value['endDate']);
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(endDate.year, endDate.month, endDate.day);

        if (DateTime.now().isAfter(startDate.subtract(const Duration(days: 1))) &&
            DateTime.now().isBefore(endDate.add(const Duration(days: 1)))) {
          DataCalendar event = DataCalendar(title: 'Event: $title', date: startDate, endDate: endDate);
          events.add(event);
        }
      });
    }
    setState(() {});
  }

  void _updateProjects(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic> eventsData = snapshot.value as Map<dynamic, dynamic>;
      eventsData.forEach((key, value) {
        String title = value['title'];
        DateTime startDate = dateFormat.parse(value['startDate']);
        DateTime endDate = dateFormat.parse(value['endDate']);
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(endDate.year, endDate.month, endDate.day);

        if (DateTime.now().isAfter(startDate.subtract(const Duration(days: 1))) &&
            DateTime.now().isBefore(endDate.add(const Duration(days: 1)))) {
          DataCalendar event = DataCalendar(title: 'Project: $title', date: startDate, endDate: endDate);
          events.add(event);
        }
      });
    }
    setState(() {});
  }

  List<DataCalendar> _getEventsFromDay(DateTime date) {
    return events.where((event) =>
    date.isAfter(event.date.subtract(const Duration(days: 0))) &&
        date.isBefore(event.endDate.add(const Duration(days: 1)))
    ).toList();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff315EFF),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat format) {
              setState(() {
                format = format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: _getEventsFromDay,
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle
              ),
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: const Color(0xff315EFF),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendTextStyle: const TextStyle(
                color: Colors.red,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: const Color(0xff315EFF),
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._getEventsFromDay(selectedDay).map(
                        (DataCalendar event) => Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              event.title,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}