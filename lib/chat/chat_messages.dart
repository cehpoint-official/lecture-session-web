import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web/chat/message_bubble.dart';
import 'package:flutter_web/main.dart';

class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages({super.key});

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(streamProvider).when(
          data: (data) {
            final content = data.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                reverse: true,
                itemBuilder: (context, index) => MessageBubble.first(
                  userImage: null,
                  username: content[index]['username'],
                  message: content[index]['message'],
                  isMe: false,
                ),
                itemCount: content.length,
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
