import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dalal_street_client/theme/colors.dart';

/// A Shimmer for texts of 3 columns
class TextShimmer extends StatelessWidget {
  const TextShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: background2,
        highlightColor: baseColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                        // width: 30,
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
                        // width: 30,
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
            ),
          ],
        ),
      ),
    );
  }
}
