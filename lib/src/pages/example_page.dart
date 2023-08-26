import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/helpers/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:photo_manager/photo_manager.dart';

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
          await _addItem(title, path);
        }
      }
      _refreshJournals();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _fetchVideos();
    _refreshJournals(); // Loading the diary when the app starts
  }

  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();

  // // This function will be triggered when the floating button is pressed
  // // It will also be triggered when you want to update an item
  // void _showForm(int? id) async {
  //   if (id != null) {
  //     // id == null -> create new item
  //     // id != null -> update an existing item
  //     final existingJournal =
  //         _journals.firstWhere((element) => element['id'] == id);
  //     _titleController.text = existingJournal['title'];
  //     _descriptionController.text = existingJournal['description'];
  //   }

  //   showModalBottomSheet(
  //       context: context,
  //       elevation: 5,
  //       isScrollControlled: true,
  //       builder: (_) => Container(
  //             padding: EdgeInsets.only(
  //               top: 15,
  //               left: 15,
  //               right: 15,
  //               // this will prevent the soft keyboard from covering the text fields
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 TextField(
  //                   controller: _titleController,
  //                   decoration: const InputDecoration(hintText: 'Title'),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 TextField(
  //                   controller: _descriptionController,
  //                   decoration: const InputDecoration(hintText: 'Description'),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     // Save new journal
  //                     if (id == null) {
  //                       // await _addItem();
  //                     }

  //                     if (id != null) {
  //                       await _updateItem(id);
  //                     }

  //                     // Clear the text fields
  //                     _titleController.text = '';
  //                     _descriptionController.text = '';

  //                     // Close the bottom sheet
  //                     if (!mounted) return;
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text(id == null ? 'Create New' : 'Update'),
  //                 )
  //               ],
  //             ),
  //           ));
  // }

// Insert a new journal to the database
  Future<void> _addItem(String title, String path) async {
    await SQLHelper.createItem(title, path);
    _refreshJournals();
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