import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:study_drive/pages/Files/AllFiles/ShowFiles/showFile.dart';
import 'package:study_drive/pages/Files/AllFiles/firebase_api.dart';

class allFilesPage extends StatefulWidget {
  @override
  _allFilesPageState createState() => _allFilesPageState();
}

class _allFilesPageState extends State<allFilesPage> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Files"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(29, 194, 95, 1),
                  minimumSize: Size.fromHeight(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, size: 28),
                    SizedBox(width: 16),
                    Text(
                      'Select File',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: selectFile,
              ),
              SizedBox(height: 8),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(29, 194, 95, 1),
                  minimumSize: Size.fromHeight(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 28),
                    SizedBox(width: 16),
                    Text(
                      'Upload File',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  uploadFile(context);
                }
              ),
              SizedBox(height: 20),
              task != null ? buildUploadStatus(task!) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile(BuildContext context) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Something Error",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
      return;
    }

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Something Error",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
      return;
    }

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          "Uploaded Successfully",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => showFiles(),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
