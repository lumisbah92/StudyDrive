import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Semister/semister.dart';

class ListDepartmentPage extends StatefulWidget {
  ListDepartmentPage({Key? key}) : super(key: key);

  @override
  _ListDepartmentPageState createState() => _ListDepartmentPageState();
}

class _ListDepartmentPageState extends State<ListDepartmentPage> {
  String role = 'user';

  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('UserList')
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
    });
  }

  final Stream<QuerySnapshot> studentsStream =
  FirebaseFirestore.instance.collection('DepartmentList').snapshots();

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

        return Scaffold(
          backgroundColor: Color(0xFFd1d1d1),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [
                      0.27,
                      0.54,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0a5275),
                      Color(0xFFd1d1d1),
                    ],
                  )
              ),
              child: SafeArea (
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 110.0, right: 10.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              'Study Drive',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 38,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Text(
                            'Deparments',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 28,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Leading University,Sylhet',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontSize: 16,
                              color: const Color(0x7cdbf1ff),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 500,
                      padding: const EdgeInsets.only(left: 32,bottom: 60),
                      child: Swiper(
                        itemCount: storedocs.length,
                        itemWidth: MediaQuery.of(context).size.width - 2 * 54,
                        layout: SwiperLayout.STACK,
                        pagination: SwiperPagination(
                          builder:
                          DotSwiperPaginationBuilder(activeSize: 20, space: 3),
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) => Semister(department: storedocs[index]['Department Name'], id: storedocs[index]['id']),
                                ),
                              );
                            },
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 100),
                                    Card(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      color: Colors.white,
                                      child: ListTile(
                                        trailing: (role == 'admin') ? SizedBox(
                                          width: 30,
                                          height: 85,
                                          child: PopupMenuButton(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: Text("Edit Semister"),
                                              ),
                                              PopupMenuItem(
                                                child: Text("Delete Semister"),
                                              ),
                                            ],
                                          ),
                                        ) : null,
                                        title: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 100,width: 250,),
                                              Text(
                                                storedocs[index]['Department Name'],
                                                style: TextStyle(
                                                  fontFamily: 'Avenir',
                                                  fontSize: 44,
                                                  color: const Color(0xff47455f),
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                'Department',
                                                style: TextStyle(
                                                  fontFamily: 'Avenir',
                                                  fontSize: 23,
                                                  color: primaryTextColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(height: 32),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                /*Hero(
                                  tag: 2,
                                  child: Image.asset("assets/images/background_for_department.png"),
                                ),*/
                                Positioned(
                                  right: 24,
                                  bottom: 60,
                                  child: Text(
                                    (index+1).toString(),
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 200,
                                      color: primaryTextColor.withOpacity(0.08),
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
