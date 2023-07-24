import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web/authentication/auth_screen.dart';
import 'package:flutter_web/firebase_options.dart';

import 'package:flutter_web/repository/chat_repo.dart';

final numberProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
    (ref) => FirebaseFirestore.instance.collection('user-data').snapshots());

final chatProvider = StateProvider<bool>((ref) => false);
final streamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchChat();
});
var first30 = true;
var last30 = false;
final first30StreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance.collection('first-30').snapshots();
});
final last30StreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance.collection('last-30').snapshots();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
