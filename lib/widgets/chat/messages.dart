import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('chat').snapshots(),
      builder: (_, chatSnapshot) =>
          chatSnapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (_, index) =>
                      Text(chatSnapshot.data.documents[index]['text']),
                  itemCount: chatSnapshot.data.documents.length,
                ),
    );
  }
}
