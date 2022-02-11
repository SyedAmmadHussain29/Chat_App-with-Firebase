import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/methods.dart';
import 'package:firebase_chat/screens/chat_screen.dart';
// import 'package:firebase_chat/widgets/auth.dart';
import 'package:firebase_chat/widgets/custom_feild.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String chatRoom(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  Map<dynamic, dynamic>? userMap = {};
  bool isloading = false;
  final TextEditingController _search = TextEditingController();

  void onSearch() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    setState(() {
      isloading = true;
    });
    await firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logOut(),
          )
        ],
      ),
      body: isloading
          ? Center(
              child: Container(
                height: s.height / 20,
                width: s.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: s.height / 20,
                ),
                Container(
                  width: s.width,
                  height: s.height / 14,
                  child: Container(
                    height: s.height / 14,
                    width: s.width / 1.15,
                    child: feild(s, 'Search', Icons.search_sharp, _search),
                  ),
                ),
                SizedBox(height: s.height / 50),
                ElevatedButton(
                    onPressed: () => onSearch(), child: Text('Search')),
                SizedBox(height: s.height / 30),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoom(
                              _auth.currentUser?.displayName ?? 'Un Available',
                              userMap!['name']);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                        chatRoom: roomId,
                                        userMap: userMap,
                                      )));
                        },
                        leading: Icon(
                          Icons.account_box_rounded,
                          color: Colors.black,
                        ),
                        title: Text(
                          userMap!['name'] ?? '',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(userMap!['email'] ?? ''),
                        trailing: Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
