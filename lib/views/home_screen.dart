import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/navigation_provider.dart';
import '../view_models/task_provider.dart';
import 'add_screen.dart';
import 'calendar_screen.dart';
import 'todo_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    TodoListScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return FutureBuilder(
      future: taskProvider.loadTasksFromFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen()));
            },
            backgroundColor: Colors.deepOrange,
            shape: CircleBorder(),
            child: Icon(Icons.add, color: Colors.white, size: 40),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: _pages[navigationViewModel.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.grey,
            currentIndex: navigationViewModel.currentIndex,
            onTap: navigationViewModel.updateIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Lịch"),
            ],
          ),
        );
      },
    );
  }
}
