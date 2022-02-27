import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';

class PostList extends StatefulWidget {
  PostList({Key? key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final Stream<QuerySnapshot> studentsStream =
  FirebaseFirestore.instance.collection('Posts').snapshots();

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
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: CircleAvatar(),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10,right: 10),
                          child: Text(
                            "Misbah Uddin Tareq",
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10,top: 10),
                      child: Icon(Icons.more_horiz),
                    )
                  ],
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 150,
                    minWidth: 150,
                    maxHeight: 350.0,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Container(
                    child: Card(
                      child: ListTile(

                      ),
                    )
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
