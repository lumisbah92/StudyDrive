import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Semister/semister.dart';

class ListDepartmentPage extends StatefulWidget {
  ListDepartmentPage({Key? key}) : super(key: key);

  @override
  _ListDepartmentPageState createState() => _ListDepartmentPageState();
}

class _ListDepartmentPageState extends State<ListDepartmentPage> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('Departments').snapshots();

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
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text(
                  "Study Drive",
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Text(
                  "Leading University",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 40, bottom: 15, left: 15, right: 15),
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      crossAxisCount: 2,
                      itemCount: storedocs.length,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child: ListTile(
                          title: Center(
                            child: Text(
                              storedocs[index]['Department Name'],
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          tileColor: kPrimaryLightColor,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Semister(
                                  department: storedocs[index]
                                      ['Department Name'],
                                ),
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
        );
      },
    );
  }
}
