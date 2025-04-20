import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/widgets/show_video_files.dart';
import 'package:flutter_video_player/src/widgets/thumbnail_show.dart';

class VideosPage extends StatefulWidget {
  final List<String> videoPath;
  final List<String> videoTitles;

  VideosPage({required this.videoPath, required this.videoTitles});
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late List<String> videos;
  late List<String> videosTitle;

  @override
  void initState() {
    super.initState();
    videos = widget.videoPath;
    videosTitle = widget.videoTitles;
    print(videos);
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
                                  '/storage/emulated/0/${widget.videoPath[index]}/${widget.videoTitles[index]}'),
                        ),
                      );
                    },
                    child: VideoThumbnailWidget(
                        videoPath:
                            '/storage/emulated/0/${widget.videoPath[index]}/${widget.videoTitles[index]}'),
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
                                  '/storage/emulated/0/${widget.videoPath[index]}/${widget.videoTitles[index]}'),
                        ),
                      );
                    },
                    child: Text(
                        '${widget.videoPath[index]}/${widget.videoTitles[index]}'),
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
