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
  late BccmPlayerController playerController;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    playerController = BccmPlayerController(
      MediaItem(
        url: '${widget.path}',
        mimeType: 'video/*',
        metadata: MediaMetadata(title: 'Apple advanced (HLS/HDR)'),
      ),
    );
    playerController.initialize().then((_) => playerController.setMixWithOthers(
        true)); // if you want to play together with other videos
    super.initState();
  }

  @override
  void dispose() {
    if (!playerController.isPrimary) {
      playerController.dispose();
    }
    super.dispose();
  }

  Future<void> _requestPermission() async {
    // Requesting the storage permission
    final status = await Permission.storage.request();

    if (status.isGranted) {
    } else if (status.isDenied) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: BccmPlayerView(
        config: BccmPlayerViewConfig(
            allowSystemGestures: false, useSurfaceView: true),
        playerController,
        //config: BccmPlayerViewConfig()
      ),
    );
  }
}
