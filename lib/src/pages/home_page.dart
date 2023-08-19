import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/widgets/intent_file.dart';
import 'package:flutter_video_player/src/widgets/show_video_files.dart';
import 'package:flutter_video_player/src/widgets/video_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: VideoList(),
    );
  }
}
// ShareReceiverWidget()