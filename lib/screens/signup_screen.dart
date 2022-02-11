import 'package:firebase_chat/methods.dart';
// import 'package:firebase_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_feild.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _name = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    bool _isloading = false;
    final Size s = MediaQuery.of(context).size;
    return Scaffold(
        body: _isloading
            ? Center(
                child: Container(
                  height: s.height / 20,
                  width: s.height / 20,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: s.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: s.width / 1.2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: s.height / 50),
                  Container(
                    width: s.width / 1.5,
                    child: Text(
                      'Welcome',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      width: s.width / 1.3,
                      child: Text(
                        'Sign In to continue',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    height: s.height / 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      // width: s.width / 10,
                      alignment: Alignment.center,
                      child: feild(s, 'Name', Icons.person, _name),
                    ),
                  ),
                  Container(
                    // width: s.width / 10,
                    alignment: Alignment.center,
                    child: feild(s, 'Email', Icons.account_box_rounded, email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      // width: s.width / 10,
                      alignment: Alignment.center,
                      child: feild(s, 'Password', Icons.lock, password),
                    ),
                  ),
                  SizedBox(
                    height: s.height / 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (_name.text.isNotEmpty &&
                            _name.text.isNotEmpty &&
                            password.text.isNotEmpty) {
                          setState(() {
                            _isloading = true;
                          });
                          createAccount(_name.text, email.text, password.text)
                              .then((user) {
                            if (user != null) {
                              setState(() {
                                _isloading = false;
                              });
                            }
                          });
                        }
                      },
                      child: customButton(s, 'Create Account')),
                  TextButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginScreen())),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ))
                ]),
              ));
  }
}
