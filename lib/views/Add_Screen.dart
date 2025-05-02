import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/Task_Provider.dart';


class AddScreen extends StatefulWidget {
  AddScreen({super.key,});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();
  late DateTime _selectedDate = DateTime.now() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm công việc"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Tiêu đề",
                border: OutlineInputBorder(),
              ),),

            SizedBox(height: 15,),

            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Mô tả",
                border: OutlineInputBorder(),
              ),),

            SizedBox(height: 15,),

            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: "Ghi chú",
                border: OutlineInputBorder(),
              ),),

            SizedBox(height: 10,),

            Row(
              children: [
                IconButton(onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),);
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },icon: Icon(Icons.calendar_today),
                ),
                SizedBox(width: 10,),
                Text(_selectedDate.toString().split(" ")[0]),
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (){
                Provider.of<TaskProvider>(context, listen: false).addTask(_titleController.text, _descriptionController.text, _selectedDate, _noteController.text);
              }, child: Text("Thêm công việc"),
            )
          ]
        )
      ),
    );
  }
}
