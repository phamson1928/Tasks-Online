import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../view_models/Task_Provider.dart'; // Model Task

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Lịch công việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TableCalendar(
                formatAnimationCurve: Curves.linear,
                formatAnimationDuration: Duration(milliseconds: 200),
                pageAnimationCurve: Curves.easeOut,
                pageAnimationDuration: Duration(milliseconds: 300),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                  leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
                  rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  leftChevronMargin: EdgeInsets.only(left: 10),
                  rightChevronMargin: EdgeInsets.only(right: 10),
                ),
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onDayLongPressed: (selectedDay, focusedDay) {
                  // Hiển thị dialog với danh sách task
                  _showTaskDialog(context, selectedDay, taskProvider);
                },
                eventLoader: (day) {
                  // Lấy danh sách task cho ngày đó
                  return taskProvider.task.where((task) {
                    return isSameDay(task.dueDate, day);
                  }).toList();
                },
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.red, // Màu của ngày có task
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent, // Màu của ngày hiện tại
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green, // Màu của ngày được chọn
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskDialog(BuildContext context, DateTime selectedDay, TaskProvider taskProvider) {
    final tasksForSelectedDay = taskProvider.task.where((task) {
      return isSameDay(task.dueDate, selectedDay);
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Task for ${selectedDay.toLocal()}'.split(' ')[0]),
        content: tasksForSelectedDay.isNotEmpty
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: tasksForSelectedDay.map((task) {
            return ListTile(
              title: Text(task.title!),
              subtitle: Text(task.description!),
            );
          }).toList(),
        )
            : Text("Không có công việc nào cho ngày này."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}