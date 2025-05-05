import 'package:flutter/material.dart';

class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners(); // Thông báo View rằng trạng thái đã thay đổi
  }
}