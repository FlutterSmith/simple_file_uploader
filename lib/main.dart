import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

File file = File('');

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(file),
              TextButton(
                onPressed: () {
                  downloadFile();
                },
                child: const Text('Upload File'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future downloadFile() async {
    var dio = Dio();

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? '');

      String filename = file.path.split('/').last;

      String filepath = file.path;

      FormData data = FormData.fromMap({
        'key': '9f2350d4be9b471c45915500f22645ac',
        'image': await MultipartFile.fromFile(filepath, filename: filename),
        'name': 'first.jpg',
      });

      var response = await dio.post('https://api.imgbb.com/1/upload',
          data: data, onSendProgress: (int sent, int total) {
        print('$sent , $total');
      });

      print(response.data);
    } else {
      print('No file selected');
    }
  }
}
