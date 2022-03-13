import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/pages/Navigation Drawer/page/DashBoard/ListCommentPage.dart';

class CommentPage extends StatefulWidget {
  String postID, Name, Email;

  CommentPage({
    required this.postID,
    required this.Name,
    required this.Email,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();

  //final DateTime timestamp = DateTime.now();
  Future<void> addComment() {
    return FirebaseFirestore.instance
        .collection("Comments")
        .doc(widget.postID)
        .collection("Comments")
        .add({
      "userID": FirebaseAuth.instance.currentUser?.uid,
      "comment": commentController.text,
      "Name": widget.Name,
      "Email": widget.Email,
      "PostID": widget.postID,
      // "timestamp": timestamp,
    });
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
            Expanded(
              child: ListCommentPage(
                  postID: widget.postID,
                  Name: widget.Name,
                  Email: widget.Email),
            ),
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
                onPressed: (){
                  addComment();
                  commentController.clear();
                },
                child: Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
