import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';

import '../profile.dart';

class ListCommentPage extends StatefulWidget {
  String postID, Name, Email;
  ListCommentPage({
    required this.postID,
    required this.Name,
    required this.Email,
  });

  @override
  State<ListCommentPage> createState() => _ListCommentPageState();
}

class _ListCommentPageState extends State<ListCommentPage> {

  Future<void> deleteComment(id) {
    return FirebaseFirestore.instance.collection('Comments').doc(widget.postID).collection("Comments").doc(id)
        .delete()
        .then((value) => print('Post Deleted'))
        .catchError((error) => print('Failed to Delete Post: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:  FirebaseFirestore.instance.collection('Comments').doc(widget.postID).collection("Comments").snapshots(),
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

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (var i = 0; i < storedocs.length; i++) ...[
                Card(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: ListTile(
                      title: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Profile(
                                Name: widget.Name,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          widget.Name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                      subtitle: Text(
                        storedocs[i]['comment'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      tileColor: kPrimaryLightColor,
                      trailing: SizedBox(
                        width: 30,
                        height: 85,
                        child:
                        (FirebaseAuth.instance.currentUser?.email ==
                            widget.Email)
                            ? PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Edit Comment"),
                            ),
                            PopupMenuItem(
                              child: Text("Delete Comment"),
                              onTap: () {
                                deleteComment(storedocs[i]['id']);
                              },
                            ),
                          ],
                        )
                            : null,
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Profile(
                                Name: widget.Name,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                              'assets/images/imageProfile.png'),
                        ),
                      ),
                      //subtitle: Text(timeago.format(timestamp.toDate())),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
