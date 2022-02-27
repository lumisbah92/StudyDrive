import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/pages/Login/login.dart';

import '../../../constants.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  var newPassword = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Your Password has been Changed. Login again !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body:
      Column(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/changePassword.png",
              width: size.width * 0.50,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 8.0),

          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      // email field
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
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Enter New Password: ",
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none,
                          errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        controller: newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3.0, top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text("Send Email"),
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: kPrimaryColor,
                              onSurface: Colors.grey,
                              side: BorderSide(color: Colors.black, width: 1),
                              elevation: 20,
                              minimumSize: Size(140,40),
                              shadowColor: Colors.teal,
                              shape: BeveledRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white,
                                      width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            onPressed:() {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    newPassword = newPasswordController.text;
                                  });
                                  changePassword();
                                }
                              }
                            },
                          ),


                        ],

                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, a, b) => Login(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                                (route) => false)
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}