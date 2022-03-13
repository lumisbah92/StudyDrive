import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Department/Department.dart';
import 'package:study_drive/pages/Login/login.dart';
import 'package:study_drive/pages/Navigation%20Drawer/page/DashBoard/dashboard.dart';
import 'package:study_drive/pages/Navigation Drawer/page/profile.dart';
import 'package:study_drive/pages/Navigation Drawer/page/change_password.dart';
import 'package:study_drive/pages/Navigation%20Drawer/page/EditProfile.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {

  final padding = EdgeInsets.symmetric(horizontal: 20);
  final storage = new FlutterSecureStorage();
  String name="";
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> studentsStream =
    FirebaseFirestore.instance.collection('UserList').snapshots();
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

        for (int i = 0; i < storedocs.length; i++) {
          if (storedocs[i]['Email'] ==
              FirebaseAuth.instance.currentUser?.email)
            name = storedocs[i]['Name'];
        }

        return Drawer(
          child: Material(
            color: kPrimaryColor,
            child: ListView(
              children: [
                for (int i = 0; i < storedocs.length; i++) ...[
                  if (storedocs[i]['Email'] ==
                      FirebaseAuth.instance.currentUser?.email) ...[
                    buildHeader(
                      name: storedocs[i]['Name'],
                      email: storedocs[i]['Email'],
                      onClicked: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            Name: storedocs[i]['Name'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
                Container(
                  padding: padding,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      buildSearchField(),
                      Divider(
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 24),
                      buildMenuItem(
                        text: 'DashBoard',
                        icon: Icons.dashboard,
                        onClicked: () => selectedItem(context, 0),
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        text: 'StudyDrive',
                        icon: Icons.attach_file,
                        onClicked: () => selectedItem(context, 1),
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        text: 'Edit Profile',
                        icon: Icons.person,
                        onClicked: () => selectedItem(context, 2),
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        text: 'Change Password',
                        icon: Icons.password,
                        onClicked: () => selectedItem(context, 3),
                      ),
                      const SizedBox(height: 24),
                      Divider(color: Colors.white70),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        text: 'Logout',
                        icon: Icons.logout,
                        onClicked: () async {
                          await FirebaseAuth.instance.signOut();
                          await storage.delete(key: "uid");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                                  (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader({
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/imageProfile.png'),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              /*CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )*/
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Department(),
        ));
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfile(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangePassword(),
          ),
        );
        break;
    }
  }
}