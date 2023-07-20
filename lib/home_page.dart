import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web/chat/chat_box.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/video/video_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
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
