import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (_, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
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
                          itemBuilder: (_, index) => MessageBubble(
                            chatSnapshot.data.documents[index]['text'],
                            chatSnapshot.data.documents[index]['userId'] ==
                                snapshot.data.uid,
                            key: ValueKey(
                                chatSnapshot.data.documents[index].documentID),
                          ),
                          itemCount: chatSnapshot.data.documents.length,
                        ),
            ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageBubble(
    this.message,
    this.isMe, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(!isMe ? 0 : 12),
                bottomRight: Radius.circular(isMe ? 0 : 12),
              )),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          width: 140,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(
                color: isMe
                    ? Colors.black
                    : Theme.of(context).accentTextTheme.headline1.color),
          ),
        ),
      ],
    );
  }
}
