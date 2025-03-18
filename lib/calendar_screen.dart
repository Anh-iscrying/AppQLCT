import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import thư viện table_calendar

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
        appBar:PreferredSize(
        preferredSize: Size.fromHeight(65.0),
    child: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Colors.amber,
    Color(0xFFF5F5DC),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
      child: AppBar(
        title: Text('Lịch'),
<<<<<<< HEAD
        backgroundColor: Colors.transparent,
=======
        backgroundColor: Color(0xFFF4A675),
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
      ),
    ),
        ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị lịch
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  // Widget hiển thị danh sách giao dịch
  Widget _buildTransactionList() {
    return Center(
      child: Text('Chọn một ngày để xem giao dịch'),
    );
  }
}