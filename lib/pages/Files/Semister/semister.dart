import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Course/courses.dart';

class Semister extends StatefulWidget {
  String department;

  Semister({required this.department});

  @override
  _SemisterState createState() => _SemisterState(department: department);
}

class _SemisterState extends State<Semister> {
  String department = "Unknown";

  _SemisterState({required this.department});

  final List semisters = [
    "1st Semister",
    "2nd Semister",
    "3rd Semister",
    "4th Semister",
    "5th Semister",
    "6th Semister",
    "7th Semister",
    "8th Semister",
    "9th Semister",
    "10th Semister",
    "11th Semister",
    "12th Semister",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semister'),
      ),
      body: Container(
        //margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text(
                    "Leading University",
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2),
                  ),
                  Text(
                    department,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                    bottom: 35,
                    left: 35,
                    right: 35,
                  ),
                  child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    crossAxisCount: 2,
                    itemCount: semisters.length,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: ListTile(
                        title: Text(
                          semisters[index],
                          style: TextStyle(fontSize: 18.0),
                        ),
                        tileColor: kPrimaryLightColor,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Courses(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
