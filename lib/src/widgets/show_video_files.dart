import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bccm_player/bccm_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String path;

  VideoPlayerScreen({required this.path});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    print('\x1B[34m  \x1B[0m');
    final file = File(widget.path);
    BccmPlayerController.primary.replaceCurrentMediaItem(
      MediaItem(
        url: file.path, // Use this instead of url
        mimeType: 'video/*',
        metadata: MediaMetadata(title: 'TEST'),
      ),
      autoplay: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    BccmPlayerController.primary.dispose();
    super.dispose();
  }

  // @override
  // void deactivate() {
  //   BccmPlayerController.primary.pause();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                VideoPlatformView(
                  playerController: BccmPlayerController.primary,
                  showControls: true,
                  useSurfaceView: true,
                ),
                ElevatedButton(
                    onPressed: () => BccmPlayerController.primary.pause(),
                    child: Text("pause"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
