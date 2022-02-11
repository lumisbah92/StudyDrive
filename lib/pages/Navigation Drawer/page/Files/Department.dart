import 'package:flutter/material.dart';

import '../../../../constants.dart';

class Department extends StatefulWidget {
  Department({Key? key}) : super(key: key);

  @override
  _DepartmentState createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
            barrierDismissible: false,
            builder: (context) =>
                Dialog(
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
                              errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Department name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 12,),
                        ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        },
      ),
      body: Center(

      ),
    );
  }
}
