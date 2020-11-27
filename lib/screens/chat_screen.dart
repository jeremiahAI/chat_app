import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('chats/JFnNHkfnylIyDNSyGXQA/messages')
            .snapshots(),
        builder: (_, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (_, index) => Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(snapshot.data.documents[index]['text']),
                        )),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Firestore.instance
                .collection('chats/JFnNHkfnylIyDNSyGXQA/messages')
                .add({'text': 'This was added!'});
          }),
    );
  }
}
