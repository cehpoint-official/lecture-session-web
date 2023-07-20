import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

class UserRepository {
  Future<void> setMessage(String name, String message) async {
    await FirebaseFirestore.instance.collection('user-chats').add(
      {
        'username': name,
        'message': message,
        'createdAt': Timestamp.now(),
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChat() {
    return FirebaseFirestore.instance
        .collection('user-chats')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
