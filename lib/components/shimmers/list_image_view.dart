import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dalal_street_client/theme/colors.dart';

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
                    ),
                  ),
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
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          width: double.infinity,
                          height: 10.0,
                          decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Container(
                          width: double.infinity,
                          height: 10.0,
                          decoration: const BoxDecoration(
                            color: blurredGray,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          width: double.infinity,
                          height: 10.0,
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
