import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/model/user.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatUser? makeUser(User? user, String email, String username) {
    return user != null
        ? ChatUser(uid: user.uid, email: email, username: username)
        : null;
  }

  Future<ChatUser?> signInAnon(String email, String username) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return makeUser(user, email, username);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
