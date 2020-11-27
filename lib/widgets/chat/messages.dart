import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (_, chatSnapshot) =>
          chatSnapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  reverse: true,
                  itemBuilder: (_, index) =>
                      Text(chatSnapshot.data.documents[index]['text']),
                  itemCount: chatSnapshot.data.documents.length,
                ),
    );
  }
}
