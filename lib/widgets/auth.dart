import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return auth();
  }
}

Widget auth() {
  FirebaseAuth _auth = FirebaseAuth.instance;
  if (_auth.currentUser != null) {
    return const Home();
  } else {
    return const LoginScreen();
  }
}
