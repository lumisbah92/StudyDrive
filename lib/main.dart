import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:study_drive/pages/Navigation Drawer/page/dashboard.dart';
import 'package:study_drive/pages/Welcome_Page/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final storage = new FlutterSecureStorage();

  Future<bool> cheakLoginStatus() async {
    String? value = await storage.read(key: "uid");
    if (value == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for Errors
        if (snapshot.hasError) {
          print("Something Went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return MaterialApp(
          title: 'Study Drive',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder(
            future: cheakLoginStatus(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              if(snapshot.data == false) return WelcomeScreen();
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator(),),
                );
              }
              return Dashboard();
            },
          ),
        );
      },
    );
  }
}
