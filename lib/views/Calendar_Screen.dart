import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/Task_Provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text(
          "Lịch công việc",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          _buildCalendar(taskProvider),
          const SizedBox(height: 20),
          _buildSelectedDayTasks(taskProvider),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Text(
            DateFormat.MMMM().format(_focusedDay),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat.y().format(_focusedDay),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          _buildFormatToggle(),
        ],
      ),
    );
  }

  Widget _buildFormatToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildFormatButton(
            label: 'Tháng',
            isActive: _calendarFormat == CalendarFormat.month,
            onTap: () => setState(() {
              _calendarFormat = CalendarFormat.month;
            }),
          ),
          _buildFormatButton(
            label: 'Tuần',
            isActive: _calendarFormat == CalendarFormat.week,
            onTap: () => setState(() {
              _calendarFormat = CalendarFormat.week;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.deepOrange,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(TaskProvider taskProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TableCalendar(
          calendarFormat: _calendarFormat,
          formatAnimationCurve: Curves.easeInOut,
          formatAnimationDuration: const Duration(milliseconds: 300),
          pageAnimationCurve: Curves.easeOut,
          pageAnimationDuration: const Duration(milliseconds: 300),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 0,  // Hide default title as we're using custom header
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.deepOrange, size: 28),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.deepOrange, size: 28),
            headerPadding: EdgeInsets.symmetric(vertical: 16),
            headerMargin: EdgeInsets.only(bottom: 8),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
            weekendStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
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
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            setState(() {});
          },
          onDayLongPressed: (selectedDay, focusedDay) {
            _showTaskDialog(context, selectedDay, taskProvider);
          },
          eventLoader: (day) {
            return taskProvider.task.where((task) {
              return isSameDay(task.dueDate, day);
            }).toList();
          },
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Colors.deepOrange.shade300,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            markersMaxCount: 3,
            markerSize: 7,
            markerMargin: const EdgeInsets.symmetric(horizontal: 1),
            todayDecoration: BoxDecoration(
              color: Colors.deepOrange.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepOrange, width: 1),
            ),
            todayTextStyle: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.deepOrange,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            outsideDaysVisible: false,
            weekendTextStyle: TextStyle(color: Colors.grey.shade600),
            defaultTextStyle: TextStyle(color: Colors.grey.shade800),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayTasks(TaskProvider taskProvider) {
    if (_selectedDay == null) return Container();

    final tasksForSelectedDay = taskProvider.task.where((task) {
      return isSameDay(task.dueDate, _selectedDay);
    }).toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  DateFormat('dd MMMM, yyyy').format(_selectedDay!),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasksForSelectedDay.length} công việc',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tasksForSelectedDay.isEmpty
                ? _buildEmptyTaskList()
                : _buildTaskList(tasksForSelectedDay),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTaskList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có công việc nào cho ngày này',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm công việc mới để hiển thị tại đây',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List tasks) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt,
                color: Colors.deepOrange,
              ),
            ),
            title: Text(
              task.title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              task.description!,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: task.note!.isNotEmpty
                ? Tooltip(
              message: task.note,
              child: const Icon(
                Icons.note,
                color: Colors.deepOrange,
                size: 20,
              ),
            )
                : null,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: task,
              );
            },
          ),
        );
      },
    );
  }

  void _showTaskDialog(BuildContext context, DateTime selectedDay, TaskProvider taskProvider) {
    final tasksForSelectedDay = taskProvider.task.where((task) {
      return isSameDay(task.dueDate, selectedDay);
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.event,
              color: Colors.deepOrange,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Công việc - ${DateFormat('dd/MM/yyyy').format(selectedDay)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.5, // More responsive height
          child: tasksForSelectedDay.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: tasksForSelectedDay.length,
            itemBuilder: (context, index) {
              final task = tasksForSelectedDay[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    if (task.note != null && task.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Ghi chú: ${task.note}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              );
            },
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_busy,
                color: Colors.grey,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "Không có công việc nào cho ngày này.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.deepOrange,
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}