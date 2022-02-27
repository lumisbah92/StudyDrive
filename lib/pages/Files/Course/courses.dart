import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Course/ListCoursesPage.dart';

class Courses extends StatefulWidget {
  Courses({Key? key}) : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final _formKey = GlobalKey<FormState>();
  var course = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final courseController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    courseController.dispose();
    super.dispose();
  }

  clearText() {
    courseController.clear();
  }

  // Adding Student
  CollectionReference courses =
  FirebaseFirestore.instance.collection('Courses');

  Future<void> addUser() {
    return courses
        .add({
      'Course': course,
    })
        .then((value) => print('Course Added'))
        .catchError((error) => print('Failed to Add Course: $error'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          icon: Icon(Icons.add),
          label: Text("Add Course"),
          onPressed: () {
            showDialog(
              context: context,
              // barrierDismissible: false,
              builder: (context) => Form(
                key: _formKey,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // Course name field
                          margin: EdgeInsets.only(top: 10),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextFormField(
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.school,
                                color: kPrimaryColor,
                              ),
                              hintText: 'Course: ',
                              border: InputBorder.none,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 15),
                            ),
                            controller: courseController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Course name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () {
                            Navigator.of(context).pop;
                            if (_formKey.currentState!.validate()) {
                              setState(
                                    () {
                                  course = courseController.text;
                                  addUser();
                                  clearText();
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        body: ListCoursesPage(),
      ),
    );
  }
}