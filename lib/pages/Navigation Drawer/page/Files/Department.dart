import 'package:flutter/material.dart';

class Department extends StatefulWidget {
  Department({Key? key}) : super(key: key);

  @override
  _DepartmentState createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deparments'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add),
        label: Text("Add Department"),
        onPressed: () {},
      ),
      body: Center(
        child: Container(
          child: Text(
            'Deparments',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}