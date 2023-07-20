import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web/chat/chat_messages.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/repository/chat_repo.dart';

class ChatBox extends ConsumerStatefulWidget {
  const ChatBox({super.key});

  @override
  ConsumerState<ChatBox> createState() => _ChatBoxState();
}

void sendMessage(String message) async {
  if (messageController.text.trim().isEmpty) {
    return;
  }
  messageController.clear();
  await UserRepository().setMessage('manas', message);
}

TextEditingController messageController = TextEditingController();

class _ChatBoxState extends ConsumerState<ChatBox> {
  @override
  Widget build(BuildContext context) {
    // final chatEnabled=ref.watch(chatProvider);
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width * 0.25,
      child: Column(
        children: [
          Container(
            // width: double.infinity,
            height: size.height * 0.07,
            color: Colors.grey,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      ref.read(chatProvider.notifier).update((state) => false);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
          ),
          const Expanded(child: ChatMessages()),
          Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.all(8),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.grey),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Send Something...',
                    border: InputBorder.none,
                  ),
                )),
                IconButton(
                    onPressed: () {
                      sendMessage(messageController.text);
                    },
                    icon: const Icon(
                      Icons.send,
                      // size: 10,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
