import 'package:flutter/material.dart';

class VideosInFolder extends StatefulWidget {
  const VideosInFolder({super.key});

  @override
  State<VideosInFolder> createState() => _VideosInFolderState();
}

class _VideosInFolderState extends State<VideosInFolder> {
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
