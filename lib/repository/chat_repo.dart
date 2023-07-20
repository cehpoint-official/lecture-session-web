import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

class UserRepository {
  final _auth = FirebaseAuth.instance;
  Future<void> setMessage(String name, String message) async {
    final userData = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(_auth.currentUser!.uid)
        .get();
    await FirebaseFirestore.instance.collection('user-chats').add(
      {
        'username': userData['username'],
        'message': message,
        'createdAt': Timestamp.now(),
        'user': _auth.currentUser!.uid,
      },
    );
  }

  Future<void> setUserData(String username, String email, String uid) async {
    await FirebaseFirestore.instance
        .collection('user-data')
        .doc(uid)
        .set({'username': username, 'email': email});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChat() {
    return FirebaseFirestore.instance
        .collection('user-chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
