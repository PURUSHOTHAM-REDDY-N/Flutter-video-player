import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/helpers/sql_helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

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
        if (path != null && title != null) {
          await generateThumbnail('/storage/emulated/0/' + path + title);
          await _addItem(title, path);
        }
      }
      _refreshJournals();
    }
  }

  Future<File?> generateThumbnail(String videoPath) async {
    final tempDir = await getExternalStorageDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir?.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 30,
      quality: 20,
    );
    print(thumbnailPath);
    return thumbnailPath != null ? File(thumbnailPath) : null;
  }

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    // _refreshJournals(); // Loading the diary when the app starts
  }

// Insert a new journal to the database
  Future<void> _addItem(String title, String path) async {
    await SQLHelper.createItem(title, path);
    // _refreshJournals();
  }

  // Update an existing journal
  // Future<void> _updateItem(int id) async {
  //   await SQLHelper.updateItem(
  //       id, _titleController.text, _descriptionController.text);
  //   _refreshJournals();
  // }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  //delete database

  Future<void> _deleteDataBase() async {
    await SQLHelper.deleteDataBase();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted the database!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ElevatedButton(
            onPressed: () => _deleteDataBase(),
            child: Text("delete  database")),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scrollbar(
              thumbVisibility: true,
              trackVisibility: false,
              interactive: true,
              thickness: 30,
              child: ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                      title: Text(_journals[index]['title']),
                      subtitle: Text(_journals[index]['path']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteItem(_journals[index]['id']),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => null,
      ),
    );
  }
}
