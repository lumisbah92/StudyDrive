import 'package:cloud_firestore/cloud_firestore.dart';
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

      body: Column(
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
              padding: EdgeInsets.only(top: 40, bottom: 35, left: 35, right: 35),
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
                    /*leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(
                      "https://media-exp1.licdn.com/dms/image/C5603AQFTNHaWoz9-DQ/profile-displayphoto-shrink_800_800/0/1619187655949?e=1649894400&v=beta&t=I2xDAgh9KRP4ksVDxRcsPrRynF24Uj7rp0etI4yQbKs"),
                ),*/
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
    );
  }
}
