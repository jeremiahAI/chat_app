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
                            chatSnapshot.data.documents[index],
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
  final DocumentSnapshot messageDocument;
  final String userId;

  bool get isMe => messageDocument['userId'] == userId;

  const MessageBubble(
    this.messageDocument,
    this.userId, {
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
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                messageDocument['username'],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline1.color),
              ),
              Text(
                messageDocument['text'],
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline1.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
