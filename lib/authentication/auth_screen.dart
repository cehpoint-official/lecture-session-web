import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/authentication/auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthServices _auth = AuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  var emailAddress = '';
  var username = '';
  Future<void> signIn() async {
    User? result = await _auth.signInAnon();
    if (result == null) {
      print('error signing in');
    } else {
      print('signed in');
      print(result);
    }
    if (usernameController.text.isEmpty || emailController.text.isEmpty) {
      return;
    }
    username = usernameController.text;
    emailAddress = emailController.text;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            height: size.height * 0.3,
            width: size.width * 0.2,
            child: SingleChildScrollView(
              child: Column(children: [
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email Address')),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Username')),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(onPressed: signIn, child: const Text('SignIn'))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
