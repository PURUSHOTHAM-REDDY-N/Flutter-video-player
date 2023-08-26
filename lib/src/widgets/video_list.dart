import 'dart:async';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_video_player/src/widgets/show_video_files.dart';
import 'package:flutter_video_player/src/widgets/thumbnail_show.dart';
import 'package:device_info_plus/device_info_plus.dart';

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<String> videos = [];
  List<String> videosTitle = [];

  @override
  void initState() {
    super.initState();
    // askPermission();
    // _fetchVideos();
    // _getStoragePermission();
    _fetchVideos();
  }

  askPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      print("granted");
    } else {
      print('not granted');
    }
  }

  _fetchVideos() async {
    // PhotoManager.setIgnorePermissionCheck(true);
    List<AssetPathEntity> entities = await PhotoManager.getAssetPathList(
      type: RequestType.video,
    );

    for (var path in entities) {
      final assets = await path.getAssetListRange(
          start: 0, end: await path.assetCountAsync);

      for (var asset in assets) {
        print(asset.duration);
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

    setState(() {});
  }

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        _fetchVideos();
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {}
    } else {
      if (await Permission.photos.request().isGranted) {
        _fetchVideos();
      } else if (await Permission.videos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.videos.request().isDenied) {}
    }
  }

  showVideo() {
    print(videos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        physics: SlowScrollPhysics(factor: 1.5),
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

class SlowScrollPhysics extends ScrollPhysics {
  final double factor;

  SlowScrollPhysics({ScrollPhysics? parent, this.factor = 2.0})
      : assert(factor != null && factor >= 1.0),
        super(parent: parent);

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor), factor: factor);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset / factor);
  }
}
