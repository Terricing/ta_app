// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ta_app/main.dart';
// import 'package:ta_app/screens/loading.dart';
import 'package:ta_app/screens/courses.dart';
import 'package:ta_app/screens/loading.dart';
import 'package:ta_app/services/courseinfo.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:developer';

Auth user = Auth("", "");
GetCourses getCourses = GetCourses();
var webController = HeadlessViewController();
// Credentials appUser = Credentials("", " ");

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text fields controllers for retrieving text
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('TeachAssist')),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // infoText("Login:"),
                FlutterLogo(
                  size: 150,
                ),
                Divider(height: 50),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Student ID'),
                  controller: userController,
                ),
                Divider(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: passController,
                ),
                Divider(height: 20),
                ElevatedButton(
                  onPressed: () {
                    user.username = userController.text;
                    user.pass = passController.text;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Loading(user)));
                  },
                  child: Text('Login'),
                )
              ]),
        ));
  }
}

// text informing login and pass
class infoText extends StatelessWidget {
  final String txt;
  const infoText(this.txt);

  @override
  Widget build(BuildContext context) {
    return Text(txt);
  }
}

void _submitCred() {}

class Alert extends StatelessWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
