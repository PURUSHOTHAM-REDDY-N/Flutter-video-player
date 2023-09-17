import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_video_player/src/widgets/videos_in_folder.dart';
import 'package:photo_manager/photo_manager.dart';

class FoldersPage extends StatefulWidget {
  const FoldersPage({
    super.key,
  });

  @override
  State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  late List<String> albumName = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlbumNames();
  }

  Future<void> getAlbumNames() async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.video);

    for (final album in albums) {
      if (album.name == "") {
        albumName.add("Others");
      } else {
        albumName.add(album.name);
      }
    }
    print(albumName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: albumName.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideosInFolder(albumname: albumName[index]),
                            ),
                          )
                        },
                    child: Text(albumName[index]))
              ],
            ),
          );
        },
      ),
    );
  }
}
