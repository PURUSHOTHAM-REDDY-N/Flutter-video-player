import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bccm_player/bccm_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_player/src/pages/home_page.dart';
import 'package:flutter_video_player/src/widgets/background_detector.dart';
import 'package:flutter_video_player/src/widgets/show_video_files.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Must be first
  await requestPermissions();
  await startPlayer();
  runApp(const BackgroundDetector(child: MyApp()));
}

Future<void> requestPermissions() async {
  // Ask for storage permission (for Android < 11)
  var storageStatus = await Permission.storage.request();

  // Ask for manage external storage (for Android 11+)
  var manageStorageStatus = await Permission.manageExternalStorage.request();

  if (storageStatus.isGranted || manageStorageStatus.isGranted) {
    print("✅ Permissions granted");
  } else {
    print("❌ Permissions denied");
    // You can show a dialog or navigate to app settings
    openAppSettings();
  }
}

Future<void> startPlayer() async {
  var data = await BccmPlayerInterface.instance.getPlayerState();
  print('\x1B[34m ${data?.playerId} \x1B[0m');
  await BccmPlayerInterface.instance.setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const IntentWidget(title: "hello"),
    );
  }
}

class IntentWidget extends StatefulWidget {
  const IntentWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<IntentWidget> createState() => _IntentWidgetState();
}

class _IntentWidgetState extends State<IntentWidget> {
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  String? _lastHandledUri;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _handleInitialUri();
    _handleIncomingLinks();
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        debugPrint("Initial URI received: $uri");
        if (!mounted) return;

        setState(() {
          _initialURI = uri;
          _lastHandledUri = uri.toString();
        });

        // 👇 Navigate manually
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(path: uri.toString()),
          ),
        );
      } else {
        debugPrint("No initial URI received");
      }
    } on PlatformException {
      debugPrint("Failed to receive initial URI");
    } on FormatException catch (err) {
      if (!mounted) return;
      debugPrint('Malformed initial URI received');
      setState(() => _err = err);
    }
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _streamSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
        if (!mounted || uri == null) return;

        debugPrint('Received URI: $uri');

        if (uri.toString() != _lastHandledUri) {
          _lastHandledUri = uri.toString();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(path: uri.toString()),
            ),
          );
        }

        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePage(
        title: "video player",
      ),
    );
  }
}
