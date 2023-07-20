import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web/authentication/auth.dart';
import 'package:flutter_web/home_page.dart';

import 'package:flutter_web/repository/chat_repo.dart';

import '../model/user.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final AuthServices _auth = AuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  var emailAddress = '';
  var username = '';

  @override
  void dispose() {
    usernameController.clear();
    emailController.clear();
    super.dispose();
  }

  Future<void> signIn() async {
    if (usernameController.text.isEmpty || emailController.text.isEmpty) {
      return;
    }

    username = usernameController.text;
    emailAddress = emailController.text;
    ChatUser? result = await _auth.signInAnon(emailAddress, username);
    if (result == null) {
      print('error signing in');
    } else {
      print('signed in');
      print(result.uid);
      if (!context.mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));

      await UserRepository()
          .setUserData(result.username, result.email, result.uid);
    }
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
