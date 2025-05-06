import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController Controller = TextEditingController();
  final String label;
  bool obscureText;

  MyTextField({super.key, required this.label, required this.Controller, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: Controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
