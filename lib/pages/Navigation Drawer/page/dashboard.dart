import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/Department/Department.dart';
import 'package:study_drive/pages/Navigation Drawer/navigation_drawer_widget.dart';
import 'package:study_drive/pages/Navigation Drawer/page/PostList.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final _formKey = GlobalKey<FormState>();
  var post = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final postController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    postController.dispose();
    super.dispose();
  }

  clearText() {
    postController.clear();
  }

  // Adding Student
  CollectionReference students =
  FirebaseFirestore.instance.collection('Posts');

  Future<void> addUser() {
    return students
        .add({
      'Post': post,
    })
        .then((value) => print('Post Added'))
        .catchError((error) => print('Failed to Add Post: $error'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard',)
      ),
      drawer: NavigationDrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kPrimaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedFontSize: 20,
        unselectedFontSize: 16,
        currentIndex: currentIndex,
        //showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "DashBoard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_file),
            label: "StudyDrive",
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Dashboard(),
              ));
              break;
            case 1:
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Department(),
              ));
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: CircleAvatar(),
                        margin: EdgeInsets.only(left: 10),
                      ),
                      Container(
                        // Post field
                        //margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.only(left: 10),
                        width: size.width * 0.8,
                        child: TextFormField(
                          autofocus: false,
                          obscureText: false,
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.more),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // Department name field
                                              margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 2),
                                              width: size.width * 0.8,
                                              decoration: BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius:
                                                    BorderRadius.circular(29),
                                              ),
                                              child: TextFormField(
                                                autofocus: false,
                                                cursorColor: kPrimaryColor,
                                                decoration: InputDecoration(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: kPrimaryColor,
                                                  ),
                                                  hintText: 'Write Something ',
                                                  border: InputBorder.none,
                                                  errorStyle: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 15),
                                                ),
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 10,
                                                minLines: 1,
                                                controller:
                                                    postController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Write Something';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: IconButton(
                                                    icon: Icon(Icons.attach_file),
                                                    onPressed: (){

                                                    },
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  child: Text('Post'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop;
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(
                                                        () {
                                                          post = postController.text;
                                                          addUser();
                                                          clearText();
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            hintText: "Write Something",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            fillColor: kPrimaryLightColor,
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 20,
                          minLines: 1,
                          // controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Post';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(
                      top: 5,
                      right: 10,
                    ),
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    child: ElevatedButton(
                      child: const Text('Post'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1),
            ),
            PostList(),
          ],
        ),
      ),
    );
  }
}
