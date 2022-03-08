import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_drive/constants.dart';
import 'package:study_drive/pages/Files/AllFiles/ShowFiles/firebase_api.dart';
import 'package:study_drive/pages/Files/AllFiles/ShowFiles/firebase_file.dart';
import 'package:study_drive/pages/Files/AllFiles/allFiles.dart';

class showFiles extends StatefulWidget {
  String Course;

  showFiles({required this.Course});

  @override
  _showFilesState createState() => _showFilesState();
}

class _showFilesState extends State<showFiles> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    String CourseName = widget.Course;
    futureFiles = FirebaseApi.listAll('$CourseName');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kPrimaryColor,
            icon: Icon(Icons.cloud_upload_sharp),
            label: Text("Upload Files"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => allFilesPage(course: widget.Course),
                ),
              );
            },
          ),
          body: FutureBuilder<List<FirebaseFile>>(
            future: futureFiles,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text('Some error occurred!'));
                  } else {
                    final files = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHeader(files.length),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];
                              final extension = file.url.split('.').last.split('?').first;
                              return buildFile(context, file, extension);
                            },
                          ),
                        ),
                      ],
                    );
                  }
              }
            },
          ),
        ),
  );
  }

  Widget buildFile(BuildContext context, FirebaseFile file, String extension) {
    var Ico = Icons.extension;
    switch(extension){
      case 'jpg':
        Ico = Icons.image;
        break;
      case 'jpeg':
        Ico = Icons.image;
        break;
      case 'png':
        Ico = Icons.image;
        break;
      case 'JPG':
        Ico = Icons.image;
        break;
      case 'JPEG':
        Ico = Icons.image;
        break;
      case 'PNG':
        Ico = Icons.image;
        break;
      case 'mp4':
        Ico = Icons.ondemand_video;
        break;
      case 'pdf':
        Ico = Icons.picture_as_pdf_sharp;
    }
    return Padding(
        padding: EdgeInsets.only(top: 5, left: 30,right: 30,),
        child: Card(
          child: ListTile(
            title: Text(
              file.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
            leading: Icon(
              Ico,
              color: Colors.blue,
            ),
            tileColor: kPrimaryLightColor,
            onTap: () {
              print("Extension : ${file.url.split('.').last.split('?').first}");
              print(file.url);
              openFile(
                  url: file.url,
              );
            },

            trailing: SizedBox(
              width: 30,
              height: 40,
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Edit File"),
                  ),
                  PopupMenuItem(
                    child: Text("Delete File"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.attach_file,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
  Future openFile({required String url, String? fileName}) async {
    final Name = fileName ?? url.split('/').last;
    final name = Name.split('?').first;
    print(name);
    final file = await downloadFile(url, name);
    if(file == null) return;

    print('Path: ${file.path}');
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }
}
