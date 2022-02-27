import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';

class ExpandedText extends StatelessWidget {
  const ExpandedText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        )
      ],
    );
  }
}
