import 'package:flutter/material.dart';

// TODO: add progress bar
// TODO: animate between changes in userInfoStream
class ChallengeProgress extends StatelessWidget {
  final int progress;
  final int targetValue;

  const ChallengeProgress({
    Key? key,
    required this.progress,
    required this.targetValue,
  }) : super(key: key);

  @override
  build(context) => Text('$progress/$targetValue');
}
