import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Navigation Drawer/page/Files/Semister/list_semister_page.dart';

class Semister extends StatefulWidget {
  Semister({Key? key}) : super(key: key);

  @override
  _SemisterState createState() => _SemisterState();
}

class _SemisterState extends State<Semister> {
  final _formKey = GlobalKey<FormState>();
  var semister = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final semisterController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    semisterController.dispose();
    super.dispose();
  }

  clearText() {
    semisterController.clear();
  }

  // Adding Student
  CollectionReference students =
      FirebaseFirestore.instance.collection('Semisters');

  Future<void> addUser() {
    return students
        .add({
          'Semister': semister,
        })
        .then((value) => print('Semister Added'))
        .catchError((error) => print('Failed to Add Semister: $error'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Semister'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        icon: Icon(Icons.add),
        label: Text("Add Semister"),
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
                        // Semister name field
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
                            hintText: 'Semister: ',
                            border: InputBorder.none,
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                          ),
                          controller: semisterController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Semister name';
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
                                semister = semisterController.text;
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
      body: ListSemisterPage(),
    );
  }
}
