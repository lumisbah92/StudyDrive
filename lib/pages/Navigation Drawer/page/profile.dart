import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has benn sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Verification Email has benn sent',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> studentsStream =
        FirebaseFirestore.instance.collection('UserList').snapshots();

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
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                for (int i = 0; i < storedocs.length; i++) ...[
                  if (storedocs[i]['Email'] ==
                      FirebaseAuth.instance.currentUser?.email) ...[
                    Text(
                      storedocs[i]['Name'],
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      storedocs[i]['Email'],
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Row(
                      children: [
                        user!.emailVerified
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'verified',
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.blueGrey),
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: TextButton(
                              onPressed: () => {verifyEmail()},
                              child: Text('Verify Email')),
                        )
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
