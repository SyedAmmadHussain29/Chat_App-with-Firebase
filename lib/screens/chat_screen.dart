import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.userMap, required this.chatRoom})
      : super(key: key);
  final Map<dynamic, dynamic>? userMap;
  final String chatRoom;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final TextEditingController _message = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Size s = MediaQuery.of(context).size;

    void onSend() async {
      if (_message.text.isNotEmpty) {
        Map<String, dynamic> messages = {
          'sendby': _auth.currentUser?.displayName,
          'message': _message.text,
          'time': FieldValue.serverTimestamp(),
        };
        messages.clear();
        await _firebase
            .collection('chatroom')
            .doc('$widget.chatRoom')
            .collection('chats')
            .add(messages);
      } else {
        print('Enter something');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userMap!['name'] ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: s.height / 1.25,
              width: s.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebase
                    .collection('chatroom')
                    .doc('$widget.chatRoom')
                    .collection('chats')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapchot) {
                  if (snapchot.data != null) {
                    return ListView.builder(
                      itemCount: snapchot.data?.docs.length,
                      itemBuilder: (context, index) {
                        Map ds = snapchot.data?.docs[index].data() as Map;
                        return messages(s, ds);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: s.height / 10,
              width: s.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: s.height / 12,
                width: s.width / 1.1,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: s.height / 17,
                    width: s.width / 1.3,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          hintText: 'Send Message',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  IconButton(
                      onPressed: () => onSend(),
                      icon: Icon(Icons.send_outlined)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size s, Map<dynamic, dynamic> ds) {
    return Container(
      width: s.width,
      alignment: ds['sendby'] == _auth.currentUser?.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Text(
          ds['message'],
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
