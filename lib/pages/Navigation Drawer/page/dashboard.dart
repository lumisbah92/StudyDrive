import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Department/Department.dart';
import 'package:study_drive/pages/Navigation Drawer/navigation_drawer_widget.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
      ),
      drawer: NavigationDrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kPrimaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 20,
        unselectedFontSize: 16,
        currentIndex: currentIndex,
        //showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "DashBoard",

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_file),
            label: "StudyDrive",
          ),
        ],
        onTap: (index) {
            setState(() {
              currentIndex = index;
            });

            switch (index) {
              case 0:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ));
                break;
              case 1:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Department(),
                ));
                break;
            }
        },
      ),
    );
  }
}
