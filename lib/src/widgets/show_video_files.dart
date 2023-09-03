import 'dart:async';
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
    BccmPlayerController.primary.initialize();
    BccmPlayerController.primary.replaceCurrentMediaItem(
        MediaItem(
          url: widget.path,
          mimeType: 'video/*',
          metadata: MediaMetadata(title: 'TEST'),
        ),
        autoplay: true);

    super.initState();
  }

  @override
  void dispose() {
    BccmPlayerController.primary.pause();
    super.dispose();
  }

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
                // ElevatedButton(
                //     onPressed: () =>
                //         BccmPlayerController.primary.enterNativeFullscreen(),
                //     child: Text("enter"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
