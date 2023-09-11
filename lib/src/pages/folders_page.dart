import 'package:flutter/material.dart';
import 'dart:core';

class FoldersPage extends StatefulWidget {
  final List<String> videoPath;
  final List<String> videoTitles;

  FoldersPage({required this.videoPath, required this.videoTitles});

  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lastWord();
  }

  lastWord() {
    String input = "WhatsApp/Media/Whats AppVideo/VID20220522181912.mp4";
    RegExp regex = RegExp(r'[^/]+');
    RegExpMatch? match = regex.firstMatch(input);

    if (match != null) {
      String? lastWord = match.group(0);
      print(lastWord);
    } else {
      print("No match found");
    }
  }

  unique() {
    Set<String> uniqueSet = Set<String>.from(widget.videoPath);
    List<String> uniqueList = uniqueSet.toList();
    print(uniqueList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: FloatingActionButton(
        onPressed: () => unique(),
        child: Text("click mme "),
      )),
    );
  }
}
