import 'package:flutter/material.dart';
import 'package:study_drive/pages/Navigation Drawer/navigation_drawer_widget.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBord'),
      ),
      drawer: NavigationDrawerWidget(),
      body: Center(
        child: Container(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
