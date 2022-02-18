import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/components/shimmers/list_image_view.dart';
import 'package:dalal_street_client/components/shimmers/text_view.dart';

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
            TextShimmer()
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Container(
                height: 15.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: blurredGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Container(
                height: 15.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: blurredGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                height: 15.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: blurredGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                height: 15.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: blurredGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
