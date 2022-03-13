import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  // Updating userlist
  CollectionReference UserList =
      FirebaseFirestore.instance.collection('UserList');

  Future<void> updateUser(name, department, semister, about) {
    return UserList.doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
          'Name': name,
          'Department': department,
          'Semister': semister,
          'About': about
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('UserList')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                var name,department,semister,about;

                for(int i=0; i<storedocs.length; i++) {
                  if(FirebaseAuth.instance.currentUser?.uid == storedocs[i]['uid']){
                    name = storedocs[i]['Name'];
                    department = storedocs[i]['Department'];
                    semister = storedocs[i]['Semister'];
                    about = storedocs[i]['About'];
                  }
                }

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 73),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 22,
                        ),
                        Container(
                          height: height * 0.7,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double innerHeight = constraints.maxHeight;
                              double innerWidth = constraints.maxWidth;
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: innerHeight * 0.8,
                                      width: innerWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              child: Image.asset(
                                                'assets/images/imageProfile.png',
                                                width: innerWidth * 0.45,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: TextFormField(
                                              initialValue: name,
                                              autofocus: false,
                                              onChanged: (value) =>
                                                  name = value,
                                              decoration: InputDecoration(
                                                labelText: 'Name: ',
                                                labelStyle:
                                                    TextStyle(fontSize: 20.0),
                                                border: OutlineInputBorder(),
                                                errorStyle: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 15),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Name';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                child: TextFormField(
                                                  initialValue: department,
                                                  autofocus: false,
                                                  onChanged: (value) =>
                                                      department = value,
                                                  decoration: InputDecoration(
                                                    labelText: 'Department: ',
                                                    labelStyle: TextStyle(
                                                        fontSize: 20.0),
                                                    border:
                                                        OutlineInputBorder(),
                                                    errorStyle: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 15),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter Department Name';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                child: TextFormField(
                                                  initialValue: semister,
                                                  autofocus: false,
                                                  onChanged: (value) =>
                                                      semister = value,
                                                  decoration: InputDecoration(
                                                    labelText: 'Semister: ',
                                                    labelStyle: TextStyle(
                                                        fontSize: 20.0),
                                                    border:
                                                        OutlineInputBorder(),
                                                    errorStyle: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 15),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter Semister';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: height * 0.35,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'About',
                                  style: TextStyle(
                                    color: Color.fromRGBO(39, 105, 171, 1),
                                    fontSize: 27,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                Divider(
                                  thickness: 2.5,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextFormField(
                                    initialValue: about,
                                    autofocus: false,
                                    onChanged: (value) => about = value,
                                    decoration: InputDecoration(
                                      labelText: 'About: ',
                                      labelStyle: TextStyle(fontSize: 20.0),
                                      border: OutlineInputBorder(),
                                      errorStyle: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 15),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter About';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Validate returns true if the form is valid, otherwise false.
                                      if (_formKey.currentState!.validate()) {
                                        updateUser(
                                          name,
                                          department,
                                          semister,
                                          about,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      'Update',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
