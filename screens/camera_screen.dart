import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:wasteagram/screens/homepage.dart';
import 'package:wasteagram/screens/new_post_screen.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera_screen';

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (File(pickedFile.path) != null) {
      setState(() {
        image = File(pickedFile.path);
      });

      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference reference =
          firebaseStorage.ref().child(DateTime.now().toString());

      UploadTask uploadTask = reference.putFile(image);
      await uploadTask.whenComplete(() => null);
      final photoURL = await reference.getDownloadURL();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewPostScreen(url: photoURL)));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
