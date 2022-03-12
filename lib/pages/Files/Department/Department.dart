import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/pages/Files/Department/list_department_page.dart';
import '../../../../../constants.dart';

class Department extends StatefulWidget {
  Department({Key? key}) : super(key: key);

  @override
  _DepartmentState createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  String role = 'user';

  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('UserList')
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
    });
  }

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
      FirebaseFirestore.instance.collection('DepartmentList');

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: (role == 'admin')
            ? FloatingActionButton.extended(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 2),
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
                                child: Text("Add"),
                                style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor,
                                  side: BorderSide(
                                      color: Colors.black, width: 0.4),
                                  elevation: 10,
                                  minimumSize: Size(100, 40),
                                  shape: BeveledRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(6.5)),
                                ),
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
              )
            : null,
        body: ListDepartmentPage(),
      ),
    );
  }
}
