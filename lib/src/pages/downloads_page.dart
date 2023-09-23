import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartorrent_common/dartorrent_common.dart';
import 'package:torrent_model/torrent_model.dart';
import 'package:torrent_task/torrent_task.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  TorrentTask? task;

  Torrent? model;

  StreamController<double> _progressStreamController =
      StreamController<double>();
  StreamController<double> _downloadSpeedStreamController =
      StreamController<double>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TorrentLoader();
    // gettingInfoHashBuffer();
  }

  gettingInfoHashBuffer() {
    // Replace this magnet link with the one you want to extract the info hash from
    final magnetLink =
        "magnet:?xt=urn:btih:6ba8f5f41b7fa22653e2f788be33b3985869b90f&dn=www.5MovieRulz.mov%20-%20Changure%20Bangaru%20Raja%20(2023)%201080p%20Telugu%20DVDScr%20x264%20AAC%202.5GB.mkv&tr=udp%3a%2f%2ftracker.openbittorrent.com%3a80%2fannounce&tr=udp%3a%2f%2ftracker.opentrackr.org%3a1337%2fannounce&tr=udp%3a%2f%2ftracker.tiny-vps.com%3a6969%2fannounce&tr=udp%3a%2f%2fopen.stealth.si%3a80%2fannounce&tr=udp%3a%2f%2fmovies.zsw.ca%3a6969%2fannounce&tr=udp%3a%2f%2fexplodie.org%3a6969%2fannounce&tr=udp%3a%2f%2fbt2.archive.org%3a6969%2fannounce&tr=udp%3a%2f%2fbt1.archive.org%3a6969%2fannounce&tr=udp%3a%2f%2ftracker2.dler.org%3a80%2fannounce&tr=udp%3a%2f%2ftracker1.bt.moack.co.kr%3a80%2fannounce&tr=http%3a%2f%2ftracker.renfei.net%3a8080%2fannounce&tr=http%3a%2f%2ftracker.gbitt.info%3a80%2fannounce&tr=udp%3a%2f%2fnew-line.net%3a6969%2fannounce&tr=udp%3a%2f%2faarsen.me%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.qu.ax%3a6969%2fannounce";

    // Extract the info hash from the magnet link
    final infoHashHex = magnetLink.split(':').last.split('&').first;

    // Convert the info hash from hexadecimal to a byte buffer
    final infoHashBuffer = Uint8List.fromList(List.generate(
        infoHashHex.length ~/ 2,
        (i) =>
            int.parse(infoHashHex.substring(i * 2, (i + 1) * 2), radix: 16)));

    // Print the info hash buffer
    return infoHashBuffer;
    // print('Info Hash Buffer: $infoHashBuffer');
  }

  TorrentLoader() async {
    var torrentFile = '/storage/emulated/0/Download/movie.mkv.torrent';

    // Specify the custom folder path
    final customFolderPath = '/storage/emulated/0/flutter video/';

    final savePath = Directory(customFolderPath);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        // Handle the case where the user denied storage permission
        print('Error: Storage permission denied.');
        return;
      }
    }

    // Ensure that the custom folder exists, or create it if it doesn't
    if (!savePath.existsSync()) {
      savePath.createSync(recursive: true);
    }
    print("this is torrent file");
    print(torrentFile);
    var model = await Torrent.parse(torrentFile);
    setState(() {
      this.model = model;
    });
    print("this is model");
    print(model.name);
    print(model.info);
    Torrent newModal = Torrent(
        null,
        "www.5MovieRulz.mov - Changure Bangaru Raja (2023) 1080p Telugu DVDScr x264 AAC 2.5GB.mkv",
        "6ba8f5f41b7fa22653e2f788be33b3985869b90f",
        gettingInfoHashBuffer());
    print("this is new model");
    print(newModal.infoHashBuffer);
    var task = TorrentTask.newTask(newModal, savePath.path);
    print("this is task");
    print(task);
    this.task = task; // Assign the task to the class-level variable

    Timer? timer;
    var startTime = DateTime.now().millisecondsSinceEpoch;
    task.onTaskComplete(() {
      print(
          'Complete! spend time : ${((DateTime.now().millisecondsSinceEpoch - startTime) / 60000).toStringAsFixed(2)} minutes');
      task.stop();
      timer?.cancel();
    });
    task.onStop(() async {
      print('Task Stopped');
    });
    var map = await task.start();

    // ignore: unawaited_futures
    await for (List<Uri>? uriList in findPublicTrackers()) {
      if (uriList != null) {
        for (var uri in uriList) {
          task.startAnnounceUrl(uri, model.infoHashBuffer!);
        }
      }
    }

    model.nodes?.forEach((element) {
      task.addDHTNode(element);
    });
    print(map);

    setState(() {});

    timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      double progressShow = task.progress;
      double downloadSpeedKBps = task.currentDownloadSpeed * 1000 / 1024;
      _progressStreamController.add(progressShow);
      _downloadSpeedStreamController.add(downloadSpeedKBps);

      var progress = '${(task.progress * 100).toStringAsFixed(2)}%';
      var ads =
          '${((task.averageDownloadSpeed) * 1000 / 1024).toStringAsFixed(2)}';
      var aps =
          '${((task.averageUploadSpeed) * 1000 / 1024).toStringAsFixed(2)}';
      var ds =
          '${((task.currentDownloadSpeed) * 1000 / 1024).toStringAsFixed(2)}';
      var ps = '${((task.uploadSpeed) * 1000 / 1024).toStringAsFixed(2)}';

      var utpd =
          '${((task.utpDownloadSpeed) * 1000 / 1024).toStringAsFixed(2)}';
      var utpu = '${((task.utpUploadSpeed) * 1000 / 1024).toStringAsFixed(2)}';
      var utpc = task.utpPeerCount;

      var active = task.connectedPeersNumber;
      var seeders = task.seederNumber;
      var all = task.allPeersNumber;
      print(
          'Progress : $progress , Peers:($active/$seeders/$all)($utpc) . Download speed : ($utpd)($ads/$ds)kb/s , upload speed : ($utpu)($aps/$ps)kb/s');
    });
  }

  stopTask() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloads"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.grey[400],

                        width: 100, // Desired width
                        height: 100,
                        child: Icon(
                          Icons.local_movies,
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(model!.name ?? "Loading..."),
                          StreamBuilder<double>(
                            stream: _progressStreamController.stream,
                            initialData: 0.0, // Initial progress is 0
                            builder: (context, progressSnapshot) {
                              double progress = progressSnapshot.data ?? 0.0;
                              return Column(
                                children: [
                                  Text(
                                      "Download Progress: ${(progress * 100).toStringAsFixed(2)}%"),
                                  LinearProgressIndicator(
                                    color: Colors.blue,
                                    value: progress,
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             StreamBuilder<double>(
//               stream: _progressStreamController.stream,
//               initialData: 0.0, // Initial progress is 0
//               builder: (context, progressSnapshot) {
//                 double progress = progressSnapshot.data ?? 0.0;
//                 return Column(
//                   children: [
//                     Text(
//                         "Download Progress: ${(progress * 100).toStringAsFixed(2)}%"),
//                     CircularProgressIndicator(value: progress),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Call the resumeTask method here
//                         resumeTask();
//                       },
//                       child: Text('Resume'),
//                     ),
//                     SizedBox(width: 16), // Add some spacing between buttons
//                     ElevatedButton(
//                       onPressed: () {
//                         // Call the pauseTask method here
//                         pauseTask();
//                       },
//                       child: Text('Pause'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             StreamBuilder<double>(
//               stream: _downloadSpeedStreamController.stream,
//               initialData: 0.0, // Initial download speed is 0
//               builder: (context, speedSnapshot) {
//                 double downloadSpeed = speedSnapshot.data ?? 0.0;
//                 return Text(
//                     "Download Speed: ${downloadSpeed.toStringAsFixed(2)} KB/s");
//               },
//             ),
//           ],
//         ),
