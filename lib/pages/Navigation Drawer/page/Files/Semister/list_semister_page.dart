import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';

class ListSemisterPage extends StatefulWidget {
  ListSemisterPage({Key? key}) : super(key: key);

  @override
  _ListSemisterPageState createState() => _ListSemisterPageState();
}

class _ListSemisterPageState extends State<ListSemisterPage> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('Semisters').snapshots();

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
                for (var i = 0; i < storedocs.length; i++) ...[
                  Card(
                    child: ListTile(
                      title: Text(
                        storedocs[i]['Semister Name'],
                        style: TextStyle(fontSize: 18.0),
                      ),
                      tileColor: kPrimaryLightColor,
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network("https://media-exp1.licdn.com/dms/image/C5603AQFTNHaWoz9-DQ/profile-displayphoto-shrink_800_800/0/1619187655949?e=1649894400&v=beta&t=I2xDAgh9KRP4ksVDxRcsPrRynF24Uj7rp0etI4yQbKs"),
                      ),
                      onTap: (){

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
