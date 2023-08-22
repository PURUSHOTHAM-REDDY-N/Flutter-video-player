import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String path;

  VideoPlayerScreen({required this.path});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.path,
    );

    // _betterPlayerController=BetterPlayerAsmsTrack(id, width, height, bitrate, frameRate, codecs, mimeType)

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
          // overlay: Center(child: Text('data', style: TextStyle(fontSize: 26))),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            playerTheme: BetterPlayerTheme.cupertino,
            enableMute: true,
            backgroundColor: Colors.black,
            audioTracksIcon: Icons.abc_sharp,
            controlsHideTime: Duration.zero,
            overflowMenuIcon: Icons.settings,
          ),
          expandToFill: true,
          showPlaceholderUntilPlay: true,
          placeholder:
              Center(child: Text('data', style: TextStyle(fontSize: 26))),
          placeholderOnTop: true,
          // playerVisibilityChangedBehavior: ,
          autoPlay: false,
          fit: BoxFit.cover,
          fullScreenByDefault: true,
          autoDetectFullscreenDeviceOrientation: true,
          autoDetectFullscreenAspectRatio: true,
          aspectRatio: 16 / 9),
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
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
      body: BetterPlayer(controller: _betterPlayerController),
    );
  }
}
