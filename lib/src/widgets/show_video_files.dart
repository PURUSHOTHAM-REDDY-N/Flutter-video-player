import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:bccm_player/bccm_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String path;

  VideoPlayerScreen({required this.path});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late BccmPlayerController controller;

  @override
  void initState() {
    // You can also use the global "primary" controller.
    // The primary player has superpowers like notification player, background playback, casting, etc:
    // final controller = BccmPlayerInterface.instance.primaryController;
    controller = BccmPlayerController(
      MediaItem(
        url: widget.path,
        mimeType: 'video/*',
        metadata: MediaMetadata(title: 'TEST'),
      ),
    );

    controller.initialize().then((_) => controller.setMixWithOthers(
        false)); // if you want to play together with other videos
    controller.enterNativeFullscreen();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracksFuture = controller.getTracks();
    return Scaffold(
      appBar: AppBar(title: Text("new")),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Column(
            children: [
              BccmPlayerView(
                controller,
                //config: BccmPlayerViewConfig()
              ),
              ElevatedButton(
                onPressed: () {
                  controller.enterNativeFullscreen();
                },
                child: const Text('Full screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  // print("asssss ${controller.value.}");
                  // controller.dispose();
                },
                child: const Text('Exit Player'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
