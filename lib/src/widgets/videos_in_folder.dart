import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../pages/videos_page.dart';

class VideosInFolder extends StatefulWidget {
  final String albumname;

  VideosInFolder({required this.albumname});

  @override
  State<VideosInFolder> createState() => _VideosInFolderState();
}

class _VideosInFolderState extends State<VideosInFolder> {
  late List<String> videos = [];
  late List<String> videosTitle = [];

  @override
  void initState() {
    super.initState();
    getVideosInFolder();
  }

  Future<void> getVideosInFolder() async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.video);

    for (final album in albums) {
      if (album.name == widget.albumname) {
        final assets =
            await album.getAssetListRange(start: 0, end: await album.assetCountAsync);
        for (var asset in assets) {
          String? path = asset.relativePath;
          String? title = asset.title;
          print(path);
          print(title);
          if (path != null) {
            videos.add(path);
          }
          if (title != null) {
            videosTitle.add(title);
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: VideosPage(videoPath: videos, videoTitles: videosTitle));
  }
}
