import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:video_player/video_player.dart';

import '../model/default_users.dart';

// final durationProvider=Provider((ref) => )
final numberProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>(
    (ref) => FirebaseFirestore.instance.collection('user-data').snapshots());

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  int getUserNo() {
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.black,
        child: Center(
          child: _controller.value.isInitialized
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: Text(
                  'video uploading...',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                )),
        ),
      ),
      Positioned(
        bottom: 0,
        left: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
      ),
      ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, child) {
            var duration =
                Duration(milliseconds: value.position.inMilliseconds.round());
            // print(duration.inSeconds);
            if (duration == value.duration && duration > Duration.zero) {
              print('yess');
            }
            var time = [duration.inMinutes, duration.inSeconds]
                .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
                .join(':');
            return Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0x1cffffff)),
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }),
      ref.watch(numberProvider).when(data: (data) {
        return Positioned(
          left: 0,
          top: 0,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0x1cffffff)),
            child: Row(
              children: [
                const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${data.docs.length + indianNames.length} Participants',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        );
      }, error: (error, stackTrace) {
        print(error.toString());
        return const Text('');
      }, loading: () {
        return const Text('');
      })
    ]);
  }
}
