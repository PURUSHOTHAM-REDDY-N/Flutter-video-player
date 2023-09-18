import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dtorrent_common/dtorrent_common.dart';
import 'package:dtorrent_parser/dtorrent_parser.dart';
import 'package:dtorrent_task/dtorrent_task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TorrentLoader();
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

    var model = await Torrent.parse(torrentFile);

    var task = TorrentTask.newTask(model, savePath.path);
    Timer? timer;
    Timer? timer1;
    var startTime = DateTime.now().millisecondsSinceEpoch;
    task.onTaskComplete(() {
      print(
          'Complete! spend time : ${((DateTime.now().millisecondsSinceEpoch - startTime) / 60000).toStringAsFixed(2)} minutes');
      timer?.cancel();
      timer1?.cancel();
      task.stop();
    });
    task.onStop(() async {
      print('Task Stopped');
    });
    var map = await task.start();

    // ignore: unawaited_futures
    findPublicTrackers().listen((alist) {
      for (var element in alist) {
        task.startAnnounceUrl(element, model.infoHashBuffer);
      }
    });
    log('Adding dht nodes');
    for (var element in model.nodes) {
      log('dht node $element');
      task.addDHTNode(element);
    }
    print(map);

    timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      var progress = '${(task.progress * 100).toStringAsFixed(2)}%';
      var ads = ((task.averageDownloadSpeed) * 1000 / 1024).toStringAsFixed(2);
      var aps = ((task.averageUploadSpeed) * 1000 / 1024).toStringAsFixed(2);
      var ds = ((task.currentDownloadSpeed) * 1000 / 1024).toStringAsFixed(2);
      var ps = ((task.uploadSpeed) * 1000 / 1024).toStringAsFixed(2);

      var utpd = ((task.utpDownloadSpeed) * 1000 / 1024).toStringAsFixed(2);
      var utpu = ((task.utpUploadSpeed) * 1000 / 1024).toStringAsFixed(2);
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
    return Container(
      child: Text("hell"),
    );
  }
}
