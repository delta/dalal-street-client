import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

// TODO: add progress bar
// TODO: animate between changes in userInfoStream
class ChallengeProgress extends StatelessWidget {
  final int progress;
  final int targetValue;

  double get percent => progress / targetValue;

  const ChallengeProgress({
    Key? key,
    required this.progress,
    required this.targetValue,
  }) : super(key: key);

  @override
  build(context) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 8,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: blurredGray,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$progress/$targetValue'),
                Text('${(percent * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
        ],
      );
}
