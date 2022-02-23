import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/methods.dart';
import 'package:firebase_chat/screens/chat_screen.dart';
import 'package:firebase_chat/widgets/custom_feild.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
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
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSearch() async {
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
    final Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logOut(),
          )
        ],
      ),
      body: isloading
          ? Center(
              child: SizedBox(
                height: s.height / 20,
                width: s.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: s.height / 20,
                ),
                SizedBox(
                  width: s.width,
                  height: s.height / 14,
                  child: SizedBox(
                    height: s.height / 14,
                    width: s.width / 1.15,
                    child: feild(s, 'Search', Icons.search_sharp, _search),
                  ),
                ),
                SizedBox(height: s.height / 50),
                ElevatedButton(
                    onPressed: () => onSearch(), child: const Text('Search')),
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
                        leading: const Icon(
                          Icons.account_box_rounded,
                          color: Colors.black,
                        ),
                        title: Text(
                          userMap!['name'] ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(userMap!['email'] ?? ''),
                        trailing: const Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    setstatus('Online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setstatus('Online');
    } else {
      setstatus('Offline');
    }

    super.didChangeAppLifecycleState(state);
  }

  void setstatus(String status) async {
    await firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'status': status,
    });
  }
}
