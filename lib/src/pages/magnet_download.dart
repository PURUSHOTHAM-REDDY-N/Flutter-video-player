import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
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
  final String infohashString = 'YOUR_MAGNET_INFO_HASH_HERE';
  final String scriptDir = Directory.current.path;

  @override
  void initState() {
    super.initState();
    // magnet();
  }

  // void magnet() async {
  //   var metadata = MetadataDownloader(infohashString);
  //   var metadataListener = metadata.createListener();

  //   metadata.startDownload();

  //   var tracker = TorrentAnnounceTracker(metadata);
  //   var trackerListener = tracker.createListener();

  //   metadataListener.on((event) async {
  //     if (event.runtimeType.toString().contains('Progress')) {
  //       // fallback in case MetaDataDownloadProgress is unavailable
  //       print('MetaDataDownload event: ${event.runtimeType}');
  //     }

  //     if (event is MetaDataDownloadComplete) {
  //       print('Metadata download complete');
  //       tracker.stop(true);

  //       var msg = decode(Uint8List.fromList(event.data));
  //       Map<String, dynamic> torrent = {};
  //       torrent['info'] = msg;

  //       var torrentModel = parseTorrentFileContent(torrent);
  //       if (torrentModel != null) {
  //         print('Torrent name: ${torrentModel.name}');
  //         var startTime = DateTime.now().millisecondsSinceEpoch;

  //         var downloadPath = path.join(scriptDir, 'tmp');
  //         var task = TorrentTask.newTask(torrentModel, downloadPath);
  //         EventsListener<TaskEvent> listener = task.createListener();

  //         listener
  //           ..on<TaskCompleted>((event) {
  //             print(
  //                 'Download complete! Time taken: ${((DateTime.now().millisecondsSinceEpoch - startTime) / 60000).toStringAsFixed(2)} minutes');
  //             task.stop();
  //           })
  //           ..on<TaskStopped>((event) {
  //             print('Task stopped');
  //           })
  //           ..on<StateFileUpdated>((event) {
  //             var progress = '${(task.progress * 100).toStringAsFixed(2)}%';
  //             var ads =
  //                 (task.averageDownloadSpeed * 1000 / 1024).toStringAsFixed(2);
  //             var aps =
  //                 (task.averageUploadSpeed * 1000 / 1024).toStringAsFixed(2);
  //             var ds =
  //                 (task.currentDownloadSpeed * 1000 / 1024).toStringAsFixed(2);
  //             var ps = (task.uploadSpeed * 1000 / 1024).toStringAsFixed(2);
  //             var utpDownloadSpeed =
  //                 (task.utpDownloadSpeed * 1000 / 1024).toStringAsFixed(2);
  //             var utpUploadSpeed =
  //                 (task.utpUploadSpeed * 1000 / 1024).toStringAsFixed(2);
  //             var utpPeerCount = task.utpPeerCount;

  //             var active = task.connectedPeersNumber;
  //             var seeders = task.seederNumber;
  //             var all = task.allPeersNumber;

  //             print(
  //                 'Progress: $progress | Peers: ($active/$seeders/$all) (UTP: $utpPeerCount) | '
  //                 'Download: ($utpDownloadSpeed)($ads/$ds) kb/s | Upload: ($utpUploadSpeed)($aps/$ps) kb/s');
  //           });

  //         await task.start();
  //       }
  //     }
  //   });

  //   var u8List = Uint8List.fromList(metadata.infoHashBuffer);
  //   trackerListener.on<AnnouncePeerEventEvent>((event) {
  //     if (event.event == null) return;
  //     var peers = event.event!.peers;
  //     for (var element in peers) {
  //       metadata.addNewPeerAddress(element, PeerSource.tracker);
  //     }
  //   });

  //   findPublicTrackers().listen((announceUrls) {
  //     for (var element in announceUrls) {
  //       tracker.runTracker(element, u8List);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Magnet download started...'),
      ),
    );
  }
}
