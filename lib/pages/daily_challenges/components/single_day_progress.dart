import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class SingleDayProgress extends StatelessWidget {
  final double progress;
  final int tasksDone;
  final int totalTasks;
  final int cashGained;
  final int totalCash;

  const SingleDayProgress({
    Key? key,
    required this.progress,
    required this.tasksDone,
    required this.totalTasks,
    required this.cashGained,
    required this.totalCash,
  }) : super(key: key);

  @override
  build(context) => SizedBox(
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
                    const Text('Progress'),
                    const SizedBox(height: 12),
                    Text('$tasksDone of $totalTasks completed'),
                    const SizedBox(height: 18),
                    Text('Reward:\n$cashGained of $totalCash'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    // Rounded corners
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      backgroundColor: blurredGray,
                      value: progress,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
