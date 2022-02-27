import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/forgot_password.dart';
import 'package:study_drive/pages/Signup/signup.dart';
import 'package:study_drive/pages/Navigation%20Drawer/page/dashboard.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  bool _secureText = true;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final storage  = new FlutterSecureStorage();

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await storage.write(key: "uid", value: userCredential.user?.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_top.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/login_bottom.png",
                  width: size.width * 0.4,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset(
                      "assets/icons/login.svg",
                      height: size.height * 0.35,
                    ),
                    SizedBox(height: size.height * 0.03),
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
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          hintText: 'Email: ',
                          border: InputBorder.none,
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      // password field
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
                        obscureText: _secureText,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Password: ",
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility,),
                            onPressed: (){
                              setState(() {
                                _secureText = !_secureText;
                              });
                            },
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none,
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      // Login Button
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                });
                                userLogin();
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // Forget Password
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                )
                              },
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      // Don't have an account?
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an Account? "),
                          TextButton(
                            onPressed: () => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, a, b) => Signup(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                  (route) => false)
                            },
                            child: Text('Signup'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
