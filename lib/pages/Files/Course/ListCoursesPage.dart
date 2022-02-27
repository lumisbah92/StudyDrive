import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/AllFiles/ShowFiles/showFile.dart';

class ListCoursesPage extends StatefulWidget {
  ListCoursesPage({Key? key}) : super(key: key);

  @override
  _ListCoursesPageState createState() => _ListCoursesPageState();
}

class _ListCoursesPageState extends State<ListCoursesPage> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('Courses').snapshots();

  /*// For Deleting User
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return students
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }*/

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: studentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Something went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Text(
                      "Leading University",
                      style: TextStyle(fontSize: 25.0, color: Colors.black),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2),
                    ),
                    Text(
                      "Semisters",
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    ),
                    Text(
                      "Courses",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                for (var i = 0; i < storedocs.length; i++) ...[
                  Card(
                    child: ListTile(
                      title: Text(
                        storedocs[i]['Course'],
                        style: TextStyle(fontSize: 18.0),
                      ),
                      tileColor: kPrimaryLightColor,
                      leading: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.school, color: Colors.black87),
                      ),
                      trailing: SizedBox(
                        width: 30,
                        height: 30,
                        child: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Edit Course"),
                            ),
                            PopupMenuItem(
                              child: Text("Delete Course"),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => showFiles(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
