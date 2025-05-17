import 'package:bccm_player/bccm_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_player/src/widgets/example_videos.dart';

class ListOfPlayers extends StatefulWidget {
  const ListOfPlayers({super.key});

  @override
  State<ListOfPlayers> createState() => _ListOfPlayersState();
}

class _ListOfPlayersState extends State<ListOfPlayers> {
  late List<BccmPlayerController> controllers;

  @override
  void initState() {
    controllers = [
      BccmPlayerController.empty(),
      ...exampleVideos.map(
        (e) => BccmPlayerController(e),
      ),
      BccmPlayerController.primary,
    ];
    for (final controller in controllers) {
      controller.initialize().then((_) => controller.setMixWithOthers(true));
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var element in controllers) {
      if (!element.isPrimary) element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...controllers.map(
          (controller) => Column(
            children: [
              BccmPlayerView(controller),
              ElevatedButton(
                  onPressed: () {
                    controller.setPrimary();
                  },
                  child: const Text('Make primary')),
            ],
          ),
        )
      ],
    );
  }
}
