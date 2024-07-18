class DataCalendar {
  final String title;
  final DateTime date;
  final DateTime endDate;
  // final Color color;

  DataCalendar({required this.title, required this.date, required this.endDate});

  @override
  String toString() => title;
}

