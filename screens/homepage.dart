import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/screens/camera_screen.dart';
import 'package:wasteagram/screens/post_details_screen.dart';
import 'package:intl/intl.dart';

class Homepage extends StatelessWidget {
  static const routeName = '/';

  const Homepage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.documents != null &&
              snapshot.data.documents.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        button: true,
        enabled: true,
        onTapHint: 'Button to add new post',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CameraScreen()));
          },
          child: Icon(Icons.photo_camera),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    DateTime now = document['date'].toDate();
    String formattedDate = DateFormat('EEEE, MMM d').format(now);

    return ListTile(
      leading: Text(
        formattedDate,
        style: TextStyle(fontSize: 17),
      ),
      trailing: Text(
        document['quantity'].toString(),
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsScreen(
              documentSnapshot: document,
            ),
          ),
        );
      },
    );
  }
}
