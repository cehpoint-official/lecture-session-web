import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web/chat/chat_box.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/repository/chat_repo.dart';
import 'package:flutter_web/video/video_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (first30) {
      ref.watch(first30StreamProvider).when(
            data: (data) async {
              final messages = data.docs;
              for (int i = 0; i < messages.length; i++) {
                await Future.delayed(const Duration(seconds: 8))
                    .then((value) async {
                  print('object');
                  await UserRepository().setMessage(
                      username: messages[i].data()['name'],
                      message: messages[i].data()['message'],
                      id: i);
                });
              }
            },
            error: (error, stackTrace) => print(error.toString()),
            loading: () => null,
          );
    }
    final chatEnabled = ref.watch(chatProvider);
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: VideoPlayerWidget()),
          if (chatEnabled) const ChatBox(),
        ],
      ),
      floatingActionButton: chatEnabled
          ? null
          : ElevatedButton.icon(
              onPressed: () {
                ref.read(chatProvider.notifier).update((state) => true);
              },
              icon: const Icon(Icons.chat_bubble_outlined),
              label: const Text('Chat With Everyone')),
    );
  }
}
