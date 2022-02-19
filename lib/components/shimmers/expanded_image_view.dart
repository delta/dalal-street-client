import 'package:dalal_street_client/components/shimmers/expanded_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/components/shimmers/list_image_view.dart';
import 'package:dalal_street_client/components/shimmers/text_column.dart';

/// A widget to display all shimmers, (useful for testing)
class AllTheShimmers extends StatelessWidget {
  const AllTheShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: const [
            ListImageViewShimmer(),
            ExpandedImageViewShimmer(),
            TextColumn()
          ],
        ),
      ),
    );
  }
}

/// A Expanded Image and Text Stacked on top of each other
/// Use case: Single News Page
class ExpandedImageViewShimmer extends StatelessWidget {
  const ExpandedImageViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: background2,
        highlightColor: baseColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              // width: 100,
              decoration: const BoxDecoration(
                color: blurredGray,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ExpandedText(),
          ],
        ),
      ),
    );
  }
}
