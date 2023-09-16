import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/widgets/show_video_files.dart';
import 'package:flutter_video_player/src/widgets/thumbnail_show.dart';
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
    // Replace 'your_folder_path' with the actual folder path
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.video);

    for (final album in albums) {
      if (album.name == widget.albumname) {
        final assets =
            await album.getAssetListRange(start: 0, end: album.assetCount);
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
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                              path:
                                  '/storage/emulated/0/${videos[index]}/${videosTitle[index]}'),
                        ),
                      );
                    },
                    child: VideoThumbnailWidget(
                        videoPath:
                            '/storage/emulated/0/${videos[index]}/${videosTitle[index]}'),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                              path:
                                  '/storage/emulated/0/${videos[index]}/${videosTitle[index]}'),
                        ),
                      );
                    },
                    child: Text(videosTitle[index]),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
