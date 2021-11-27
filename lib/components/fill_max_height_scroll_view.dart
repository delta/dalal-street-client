import 'package:flutter/material.dart';

/// See `Expanding content to fit the viewport` section in [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html)
class FillMaxHeightScrollView extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const FillMaxHeightScrollView({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) =>
            SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: IntrinsicHeight(
              child: builder(context),
            ),
          ),
        ),
      );
}
