import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostDetailsScreen extends StatelessWidget {
  static const routeName = '/post_details';

  final DocumentSnapshot documentSnapshot;
  PostDetailsScreen({Key key, this.documentSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime displayDate = documentSnapshot['date'].toDate();
    String formattedDate = DateFormat('EEEE, MMM d, y').format(displayDate);

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Post Details'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 400,
                width: 200,
                child: Image.network(documentSnapshot['imageURL']),
              ),
              Text(
                'Items: ${documentSnapshot['quantity'].toString()}',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                  'Coordinates: ${documentSnapshot['longitude'].toString()}, ${documentSnapshot['latitude'].toString()}')
            ],
          ),
        ),
      ),
    );
  }
}
