import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoPath;

  VideoThumbnailWidget({required this.videoPath});

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  Future<File?>? thumbnailFuture;

  @override
  void initState() {
    super.initState();
    thumbnailFuture = generateThumbnail(widget.videoPath);
  }

  Future<File?> generateThumbnail(String videoPath) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.WEBP,
      // maxHeight: 350,
      // maxWidth: 350,
      quality: 20,
    );
    return thumbnailPath != null ? File(thumbnailPath.path) : null;
    // final thumbnailGenerated = await plugin.getVideoThumbnail(
    //     srcFile: videoPath,
    //     destFile: tempDir.path,
    //     width: 300,
    //     height: 300,
    //     keepAspectRatio: true,
    //     format: 'jpeg',
    //     quality: 90);
    // return thumbnailGenerated != false ? File(tempDir.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ClipRRect(
            borderRadius:
                BorderRadius.circular(5), // Adjust for desired rounding
            child: Container(
              color: Colors.grey[400],

              width: 100, // Desired width
              height: 100, // Desired height
              child: Icon(
                Icons.local_movies,
              ),
            ),
          ); // Loading indicator while waiting
        } else if (snapshot.error != null) {
          return Icon(Icons.error); // Error indicator if something went wrong
        } else if (snapshot.data != null) {
          return Container(
            width: 200, // Desired width
            height: 300, // Desired height
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(5), // Adjust for desired rounding
              child: Image.file(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Icon(Icons.error); // Placeholder in case of no thumbnail
        }
      },
    );
  }
}
