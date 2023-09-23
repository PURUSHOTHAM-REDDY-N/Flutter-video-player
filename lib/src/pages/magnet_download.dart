import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:typed_data';

import 'package:b_encode_decode/b_encode_decode.dart';
import 'package:dtorrent_common/dtorrent_common.dart';
import 'package:dtorrent_parser/dtorrent_parser.dart';
import 'package:dtorrent_task/src/metadata/metadata_downloader.dart';
import 'package:dtorrent_task/dtorrent_task.dart';
import 'package:dtorrent_tracker/dtorrent_tracker.dart';
import 'package:permission_handler/permission_handler.dart';

class MagnetDownload extends StatefulWidget {
  const MagnetDownload({super.key});

  @override
  State<MagnetDownload> createState() => _MagnetDownloadState();
}

class _MagnetDownloadState extends State<MagnetDownload> {
  @override
  void initState() {
    super.initState();
    magnet();
  }

  void magnet() async {
    var infohashString = '94acca48015a8af0d86a69c9fc45b0ec070d5642';
    var metadata = MetadataDownloader(infohashString);
    print("hello");
    // Metadata download contains a DHT , it will search the peer via DHT,
    // but it's too slow , sometimes DHT can not find any peers
    metadata.startDownload();
    // so for this example , I use the public trackers to help MetaData download to search Peer nodes:
    var tracker = TorrentAnnounceTracker(metadata);

    // When metadata contents download complete , it will send this event and stop itself:
    metadata.onDownloadComplete((data) async {
      tracker.stop(true);
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
      var msg = decode(Uint8List.fromList(data));
      Map<String, dynamic> torrent = {};
      torrent['info'] = msg;
      var torrentModel = parseTorrentFileContent(torrent);
      if (torrentModel != null) {
        print('complete , info : ${torrentModel.name}');
        var startTime = DateTime.now().millisecondsSinceEpoch;
        var task = TorrentTask.newTask(torrentModel, savePath.path);
        Timer? timer;
        task.onTaskComplete(() {
          print(
              'Complete! spend time : ${((DateTime.now().millisecondsSinceEpoch - startTime) / 60000).toStringAsFixed(2)} minutes');
          timer?.cancel();
          task.stop();
        });
        task.onStop(() async {
          print('Task Stopped');
        });
        timer = Timer.periodic(Duration(seconds: 2), (timer) async {
          var progress = '${(task.progress * 100).toStringAsFixed(2)}%';
          var ads =
              ((task.averageDownloadSpeed) * 1000 / 1024).toStringAsFixed(2);
          var aps =
              ((task.averageUploadSpeed) * 1000 / 1024).toStringAsFixed(2);
          var ds =
              ((task.currentDownloadSpeed) * 1000 / 1024).toStringAsFixed(2);
          var ps = ((task.uploadSpeed) * 1000 / 1024).toStringAsFixed(2);

          var utpDownloadSpeed =
              ((task.utpDownloadSpeed) * 1000 / 1024).toStringAsFixed(2);
          var utpUploadSpeed =
              ((task.utpUploadSpeed) * 1000 / 1024).toStringAsFixed(2);
          var utpPeerCount = task.utpPeerCount;

          var active = task.connectedPeersNumber;
          var seeders = task.seederNumber;
          var all = task.allPeersNumber;
          print(
              'Progress : $progress , Peers:($active/$seeders/$all)($utpPeerCount) . Download speed : ($utpDownloadSpeed)($ads/$ds)kb/s , upload speed : ($utpUploadSpeed)($aps/$ps)kb/s');
        });
        await task.start();
      }
    });

    var u8List = Uint8List.fromList(metadata.infoHashBuffer);

    tracker.onPeerEvent((source, event) {
      if (event == null) return;
      var peers = event.peers;
      for (var element in peers) {
        metadata.addNewPeerAddress(element, PeerSource.tracker);
      }
    });
    findPublicTrackers().listen((announceUrls) {
      for (var element in announceUrls) {
        tracker.runTracker(element, u8List);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
