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
                  // itemBuilder: (_, index) =>
                  //     Text(chatSnapshot.data.documents[index]['text']),
                  itemBuilder: (_, index) =>
                      MessageBubble(chatSnapshot.data.documents[index]['text']),
                  itemCount: chatSnapshot.data.documents.length,
                ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  const MessageBubble(
    this.message, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          width: 140,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(
                color: Theme.of(context).accentTextTheme.headline1.color),
          ),
        ),
      ],
    );
  }
}
