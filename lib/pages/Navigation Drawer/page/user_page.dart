import 'package:flutter/material.dart';
import 'package:study_drive/constants.dart';

class UserPage extends StatelessWidget {
  final String name;

  const UserPage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(name),
          centerTitle: true,

        ),
        body: Image.asset(
          'assets/images/imageProfile.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
}
