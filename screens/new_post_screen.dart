import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/posts.dart';
import 'package:wasteagram/screens/homepage.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = '/new_post';

  final String url;

  NewPostScreen({Key key, this.url}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  LocationData locationData;
  Post post = Post();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  void addNonQuantityPostData() {
    post.date = DateTime.now();
    post.longitude = locationData.longitude;
    post.latitude = locationData.latitude;
    post.imageURL = widget.url;
  }

  Widget build(BuildContext context) {
    if (locationData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 400,
                      width: 200,
                      child: Image.network(widget.url),
                    ),
                    Center(
                      child: TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'Number of wasted items',
                        ),
                        keyboardType: TextInputType.number,
                        // validator: (value) =>
                        //     value.isEmpty ? 'Please enter a quantity' : null,
                        onSaved: (value) => post.quantity = int.parse(value),
                      ),
                    ),
                    SizedBox(height: 115),
                    Semantics(
                      button: true,
                      enabled: true,
                      onTapHint: 'Upload post with photo',
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        height: 100,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton(
                            child: Icon(Icons.upload_file),
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                addNonQuantityPostData();
                                FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc()
                                    .set(
                                  {
                                    'quantity': post.quantity,
                                    'date': post.date,
                                    'longitude': post.longitude,
                                    'latitude': post.latitude,
                                    'imageURL': post.imageURL
                                  },
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage()),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
