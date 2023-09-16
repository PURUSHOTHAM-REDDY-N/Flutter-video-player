import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/pages/videos_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_video_player/src/pages/folders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> videos = [];
  late List<String> videosTitle = [];
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      VideosPage(
        videoPath: videos,
        videoTitles: videosTitle,
      ),
      FoldersPage(),
      Text("hello"),
    ];
    print(videos);
    Future.microtask(() async {
      // Your asynchronous code here
      await _fetchVideos();

      if (mounted) {
        // Always check if the widget is still in the tree
        setState(() {
          pages = [
            VideosPage(
              videoPath: videos,
              videoTitles: videosTitle,
            ),
            FoldersPage(),
            Text("hello"),
          ];
        });
      }
    });
  }

  int _selectedIndex = 0;

  _fetchVideos() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            onTabChange: (value) => setState(() {
              _selectedIndex = value;
            }),
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade700,
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.movie_creation,
                text: 'Videos',
              ),
              GButton(
                icon: Icons.folder,
                text: 'Folders',
              ),
              GButton(
                icon: Icons.file_download,
                text: 'Downloads',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// appBar: AppBar(title: const Text("Video Player")),
//       body: VideoList(),

// const Text("Video Player")
// ElevatedButton(
//             onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ExamplePage(),
//                   ),
//                 ),
//             child: Text('click me')),
