import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/Navigation_Provider.dart';
import 'Add_Screen.dart';
import 'Calendar_Screen.dart';
import 'Toto_List_Screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    TodoListScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
