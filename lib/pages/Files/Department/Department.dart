import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/pages/Files/Department/list_department_page.dart';

import '../../../../../constants.dart';

class Department extends StatefulWidget {
  Department({Key? key}) : super(key: key);

  @override
  _DepartmentState createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  final _formKey = GlobalKey<FormState>();
  var department = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final departmentController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    departmentController.dispose();
    super.dispose();
  }

  clearText() {
    departmentController.clear();
  }

  // Adding Student
  CollectionReference students =
      FirebaseFirestore.instance.collection('Departments');

  Future<void> addUser() {
    return students
        .add({
          'Department Name': department,
        })
        .then((value) => print('Department Added'))
        .catchError((error) => print('Failed to Add Department: $error'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background_for_department.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            )),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Departments'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          icon: Icon(Icons.add),
          label: Text("Add Department"),
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
                          // Department name field
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
                              hintText: 'Department Name: ',
                              border: InputBorder.none,
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 15),
                            ),
                            controller: departmentController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Department name';
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
                                  department = departmentController.text;
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListDepartmentPage(),
            ],
          ),
        ),
      ),
    );
  }
}
