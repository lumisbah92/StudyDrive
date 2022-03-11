import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Navigation Drawer/page/CommentPage.dart';

class PostList extends StatefulWidget {
  PostList({Key? key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('Posts').snapshots();

  final String currentUserID = FirebaseAuth.instance.currentUser!.uid;

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

        for (var i = 0; i < storedocs.length; i++) {
          if (storedocs[i]['Likes'][currentUserID] == null)
            FirebaseFirestore.instance
                .collection('Posts')
                .doc(storedocs[i]['id'])
                .update({
              'Likes.$currentUserID': false,
            });
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  for (var i = 0; i < storedocs.length; i++) ...[
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage(
                                    'assets/images/imageProfile.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                storedocs[i]['Name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 10),
                          child: PopupMenuButton(
                            icon: Icon(Icons.more_horiz),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text("Edit Post"),
                              ),
                              PopupMenuItem(
                                child: Text("Delete Post"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      width: 350,
                      color: kPrimaryLightColor,
                      child: Text(
                        storedocs[i]['Post'],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 40),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: GestureDetector(
                                  onTap: () {
                                    int LikeCount = storedocs[i]['Like Count'];
                                    String PostID = storedocs[i]['id'];
                                    if (storedocs[i]['Likes'][currentUserID] !=
                                        true) {
                                      setState(() {
                                        storedocs[i]['Likes'][currentUserID] =
                                            true;
                                        LikeCount++;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('Posts')
                                          .doc(PostID)
                                          .update({
                                        'Likes.$currentUserID': true,
                                        'Like Count': LikeCount
                                      });
                                    } else {
                                      setState(() {
                                        storedocs[i]['Likes'][currentUserID] =
                                            false;
                                        LikeCount--;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('Posts')
                                          .doc(PostID)
                                          .update({
                                        'Likes.$currentUserID': false,
                                        'Like Count': LikeCount
                                      });
                                    }
                                  },
                                  child: Icon(
                                    storedocs[i]['Likes'][currentUserID]
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 30.0,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  storedocs[i]['Like Count'].toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 100),
                          alignment: Alignment.center,
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.33,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CommentPage(postID: storedocs[i]['id'],),
                                    ));
                                  },
                                  child: Icon(Icons.comment),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CommentPage(postID: storedocs[i]['id'],),
                                    ));
                                  },
                                  child: Text(
                                    "Comment",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
