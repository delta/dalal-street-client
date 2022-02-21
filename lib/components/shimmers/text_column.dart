import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dalal_street_client/theme/colors.dart';

/// A Shimmer for texts of 3 columns
class TextColumn extends StatelessWidget {
  const TextColumn({Key? key, int? columns}) : super(key: key);

  final int columns = 4;

  static Widget singleColumn = Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12.0,
            decoration: const BoxDecoration(
              color: blurredGray,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
          const SizedBox(
            height: 7.0,
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Container(
              height: 12.0,
              decoration: const BoxDecoration(
                color: blurredGray,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 7.0,
          ),
          FractionallySizedBox(
            widthFactor: 0.85,
            child: Container(
              height: 12.0,
              decoration: const BoxDecoration(
                color: blurredGray,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 7.0,
          ),
        ],
      ),
    ),
  );

  // List<Widget> columnWidget = List<Widget>.filled(columns, SingleColumn);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: background2,
        highlightColor: baseColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.filled(columns, singleColumn).toList(),
        ),
      ),
    );
  }
}
