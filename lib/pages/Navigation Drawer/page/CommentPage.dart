import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  String postID;

  CommentPage({required this.postID});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  final commentRefs = FirebaseFirestore.instance.collection("Comments");

  //final DateTime timestamp = DateTime.now();

  buildComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentRefs
          .doc(widget.postID)
          .collection('Comments')
          //.orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Something went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

       List<Comment> comments = [];
        snapshot.data?.docs.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(children: comments,);
      },
    );
  }

  addComment() {
    commentRefs.doc(widget.postID).collection("Comments").add({
      "userID": FirebaseAuth.instance.currentUser?.uid,
      "comment": commentController.text,
     // "timestamp": timestamp,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: Text(
                  "Comments",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
              Expanded(child: buildComments()),
              Divider(),
              ListTile(
                title: TextFormField(
                  maxLines: 20,
                  minLines: 1,
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: "Write a Comment...",
                  ),
                ),
                trailing: OutlinedButton(
                  onPressed: addComment,
                  child: Text("Post"),
                ),
              ),
            ],
          )),
    );
  }
}

class Comment extends StatelessWidget {
  final String comment;
  final String userID;
  //final String timestamp;

  Comment({
    required this.comment,
    required this.userID,
    //required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      comment: doc['comment'],
      userID: doc['userID'],
     // timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('$comment'),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/imageProfile.png'),
          ),
          //subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}
