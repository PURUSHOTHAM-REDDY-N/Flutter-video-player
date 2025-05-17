import 'package:bccm_player/bccm_player.dart';
import 'package:flutter/material.dart';

class BackgroundDetector extends StatefulWidget {
  const BackgroundDetector({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<BackgroundDetector> createState() => _BackgroundDetectorState();
}

class _BackgroundDetectorState extends State<BackgroundDetector>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('\x1B[34m $state \x1B[0m');
    // if (state == AppLifecycleState.resumed) {
    //   BccmPlayerController.primary.play();
    // } else if (state == AppLifecycleState.paused) {
    //   BccmPlayerController.primary.pause();
    // } else if (state == AppLifecycleState.hidden) {
    //   BccmPlayerController.primary.pause();
    // } else if (state == AppLifecycleState.inactive) {
    //   BccmPlayerController.primary.pause();
    // }
    if (state == AppLifecycleState.paused) {
      BccmPlayerController.primary.pause();
    } else if (state == AppLifecycleState.resumed) {
      BccmPlayerController.primary.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
