import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/navigation_provider.dart';
import '../view_models/task_provider.dart';
import 'add_screen.dart';
import 'calendar_screen.dart';
import 'todo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [
    TodoListScreen(),
    CalendarScreen(),
  ];
  bool _isLoading = true;

  void initState() {
    super.initState();
    // Gọi 1 lần để load dữ liệu từ Firebase
    Future.microtask(() async {
      await Provider.of<TaskProvider>(context, listen: false).loadTasksFromFirebase();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen()));
        },
        backgroundColor: Colors.deepOrange,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Color.fromRGBO(255, 255, 255, 1), size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[navigationViewModel.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        currentIndex: navigationViewModel.currentIndex,
        onTap: (index) {
          navigationViewModel.updateIndex(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home ), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Lịch"),
        ],
      ),
    );
  }
}