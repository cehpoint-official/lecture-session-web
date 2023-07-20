import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.black,
        child: const Center(
            child: Text(
          'video',
          style: TextStyle(color: Colors.white, fontSize: 50),
        )),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0x1cffffff)),
          child: const Text(
            '00:00',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0x1cffffff)),
          child: const Row(
            children: [
              Icon(
                Icons.people,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '22 Participants',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
