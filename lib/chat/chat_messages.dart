import 'package:firebase_auth/firebase_auth.dart';
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
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return ref.watch(streamProvider).when(
          data: (data) {
            final loadedMessages = data.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                reverse: true,
                itemBuilder: (context, index) {
                  final chatMessage = loadedMessages[index].data();
                  final nextChatMessage = index + 1 < loadedMessages.length
                      ? loadedMessages[index + 1].data()
                      : null;
                  final currentMessageUserId = chatMessage['user'];
                  final nextMessageUserId =
                      nextChatMessage != null ? nextChatMessage['user'] : null;
                  final nextUserIsSame =
                      (nextMessageUserId == currentMessageUserId);
                  if (chatMessage['username'] == 'cehpoint support') {
                    return Container(
                        color: Colors.blue,
                        child: nextUserIsSame
                            ? MessageBubble.next(
                                message: chatMessage['message'],
                                isMe: (authenticatedUser.uid ==
                                    currentMessageUserId))
                            : MessageBubble.first(
                                userImage: null,
                                username: chatMessage['username'],
                                message: chatMessage['message'],
                                isMe: (authenticatedUser.uid ==
                                    currentMessageUserId)));
                  } else {
                    if (nextUserIsSame) {
                      return MessageBubble.next(
                          message: chatMessage['message'],
                          isMe:
                              (authenticatedUser.uid == currentMessageUserId));
                    } else {
                      return MessageBubble.first(
                          userImage: null,
                          username: chatMessage['username'],
                          message: chatMessage['message'],
                          isMe:
                              (authenticatedUser.uid == currentMessageUserId));
                    }
                  }
                },
                itemCount: loadedMessages.length,
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
