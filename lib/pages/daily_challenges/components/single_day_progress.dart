import 'package:dalal_street_client/models/daily_challenge_info.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SingleDayProgress extends StatelessWidget {
  final List<DailyChallengeInfo> challengeInfos;

  const SingleDayProgress({
    Key? key,
    required this.challengeInfos,
  }) : super(key: key);

  @override
  build(context) {
    final completedTasks = challengeInfos.where((x) => x.userState.isCompleted);
    final tasksDone = completedTasks.length;
    final totalTasks = challengeInfos.length;
    final cashGained = (completedTasks.isNotEmpty)
        ? completedTasks.map((e) => e.challenge.reward).reduce((a, b) => a + b)
        : 0;
    final totalCash =
        challengeInfos.map((e) => e.challenge.reward).reduce((a, b) => a + b);
    final progress = tasksDone / totalTasks;
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: background2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$tasksDone of $totalTasks completed',
                    style: const TextStyle(color: blurredGray, fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Reward:',
                    style: TextStyle(color: lightGray, fontSize: 16),
                  ),
                  Text(
                    '$cashGained of $totalCash',
                    style: const TextStyle(color: lightGray, fontSize: 12),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircularPercentIndicator(
                  radius: 90,
                  lineWidth: 8,
                  animation: true,
                  percent: progress,
                  center: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 18),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: blurredGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
