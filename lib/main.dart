import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/pages/home_page.dart';
import 'package:bccm_player/bccm_player.dart';

void main() {
  startPlayer();
  runApp(const MyApp());
}

startPlayer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BccmPlayerInterface.instance.setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(
        title: "video player",
      ),
    );
  }
}
