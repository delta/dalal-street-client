/// A bunch of re-useable shimmer widgets for various use cases
/// Shimmers are visual indicators that data is being fetched
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dalal_street_client/theme/colors.dart';

/// A widget to display all shimmers, (useful for testing)
class AllTheShimmers extends StatelessWidget {
  const AllTheShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: SafeArea(
        child: Column(children: const [
          ListImageViewShimmer(),
          ExpandedImageViewShimmer(),
          TextShimmer()
        ]),
      )),
    );
  }
}

/// A shimmer with a image and text stacked next to each other
/// UseCase: This can be used in places with where both image and text are
/// loaded (Like news_list_page)
class ListImageViewShimmer extends StatelessWidget {
  const ListImageViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: background2,
        highlightColor: baseColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 128.0,
                  height: 72.0,
                  decoration: const BoxDecoration(
                      color: blurredGray,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                // to occupy 100% of width
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
                    )),
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
                      )),
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
                      )),
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
                      )),
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
                      )),
                ),
              ),
            ],
          )),
    );
  }
}

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
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12.0,
                        // width: 30,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
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
                              )),
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
                              )),
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
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12.0,
                        // width: 30,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
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
                              )),
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
                              )),
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
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12.0,
                        // width: 30,
                        decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
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
                              )),
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
                              )),
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
          )),
    );
  }
}
