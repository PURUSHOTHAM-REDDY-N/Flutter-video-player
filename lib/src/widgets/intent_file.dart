import 'dart:async';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareReceiverWidget extends StatefulWidget {
  @override
  _ShareReceiverWidgetState createState() => _ShareReceiverWidgetState();
}

class _ShareReceiverWidgetState extends State<ShareReceiverWidget> {
  late StreamSubscription<List<SharedMediaFile>?> _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;

  @override
  void initState() {
    super.initState();

    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile>? value) {
      setState(() {
        _sharedFiles = value;
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing files coming from outside the app while the app is in the background
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile>? value) {
      setState(() {
        _sharedFiles = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sharedFiles != null && _sharedFiles!.isNotEmpty) {
      SharedMediaFile sharedMediaFile = _sharedFiles!.first;
      if (sharedMediaFile.type == SharedMediaType.VIDEO) {
        return _buildVideo(sharedMediaFile.path);
      }
    }

    return Center(child: Text("No video received"));
  }

  Widget _buildVideo(String? path) {
    return (path != null)
        ? Container(
            child: Text("Received Video Path: $path"),
            // Here, you can use a video player package to play the video
          )
        : Container();
  }
}
